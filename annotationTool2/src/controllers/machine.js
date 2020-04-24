let should = require('should');
let Router = require('koa-router');
let assert = require('assert');
let uuidv1 = require('uuid/v1');
let mzfs = require('mz/fs');
let path = require('path');
let moment = require('moment');
let config = require('../config');
let { DatasetItem, Task, TaskItem } = require('../models');
let send = require('koa-send');

// 主动学习
// 下载文件:
// [{
//     id: String,
//     content: String,
//     tags: [{
//         length: Number,
//         symbol: String
//     }]
// }]
// 上传文件：
// [{
//     id: String,
//     confidence: Number,
//     tags: [{
//         length: Number,
//         symbol: String
//     }]
// }]

let preparing = false;
let preparing_error = null;
async function prepareMachineData (task, uuid) {
    preparing = true;
    preparing_error = null;

    try {
        task.machine_status = `[${moment().format('YYYY-MM-DD HH:mm')}]` + '准备数据中';
        await task.save();

        let data = [];
        let dataset_item_ids = [];
        for (let i = 0, batch_size = 1024; ; i++) {
            let chunk = await TaskItem.find({by_human: true, task}).skip(i * batch_size).limit(batch_size).populate('dataset_item');
            if (chunk.length === 0) break;
            for (let item of chunk) {
                data.push({
                    id: item.dataset_item.id,
                    content: item.dataset_item.content,
                    tags: item.tags
                });
                dataset_item_ids.push(item.dataset_item._id);
            }
        }
        while (true) {
            let chunk = await DatasetItem.find({dataset: task.dataset, _id: {$not: {$in: dataset_item_ids}}}).limit(1024);
            if (chunk.length === 0) break;
            for (let dataset_item of chunk) {
                data.push({
                    id: dataset_item.id,
                    content: dataset_item.content
                });
                dataset_item_ids.push(dataset_item._id);
            }
        }
        await mzfs.writeFile(path.join(config.FILE_PATH, uuid), JSON.stringify(data));

        task.machine_status = `[${moment().format('YYYY-MM-DD HH:mm')}]` + '准备数据完毕';
        await task.save();
    } catch (e) {
        console.error(e);
        preparing_error = e;
    }

    preparing = false;
}

const router = module.exports = new Router();

router.use(async (ctx, next) => {
    assert(ctx.query.key === config.MACHINE_CLIENT_KEY, 'key不正确');
    await next();
});

router.get('/get_machine_task', async ctx => {
    if (preparing) {
        return ctx.body = {
            success: true,
            task: null
        };
    }
    let task = await Task.findOne({machine_running: true, is_deleted: false});
    if (!task) {
        return ctx.body = {
            success: true,
            task: null
        };
    }
    let uuid = uuidv1();
    prepareMachineData(task, uuid);
    ctx.body = {
        success: true,
        task: {
            task_id: task._id,
            uuid: uuid
        }
    };
});

router.get('/get_machine_task/prepare_status', async ctx => {
    if (preparing) {
        return ctx.body = {
            success: true,
            preparing
        };
    }
    if (preparing_error) {
        return ctx.body = {
            success: true,
            preparing,
            preparing_error: preparing_error.message
        };
    }
    return ctx.body = {
        success: true,
        preparing,
        preparing_error: null
    };
});

// ?task_id, uuid
router.get('/get_machine_task/download', async ctx => {
    let task = await Task.findById(ctx.query.task_id);
    assert(task, '参数错误');
    task.machine_status = `[${moment().format('YYYY-MM-DD HH:mm')}]` + '正在学习中';
    await task.save();

    await send(ctx, ctx.query.uuid, {root: config.FILE_PATH});
});

// task_id, data
router.post('/upload_machine_task', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id).populate('dataset');
    assert(task, '参数错误');

    let passed_cnt = 0;
    for (let item of ctx.request.body.data) {
        let dataset_item = await DatasetItem.findOne({dataset: task.dataset, id: item.id});
        if (dataset_item) {
            if (!await TaskItem.findOne({task, dataset_item, by_human: true})) {
                let start = 0;
                for (let t of item.tags) {
                    should(t).an.Object().and.has.property('length').an.Number();
                    should(t).an.Object().and.has.property('symbol').a.String();
                    should(t).an.Object().and.has.property('text').a.String();
                    assert(t.length > 0);
                    assert(t.symbol.length > 0);
                    assert(t.text.length > 0);
                    start += t.length;
                }
                assert(start === dataset_item.content.length);

                await TaskItem.findOneAndUpdate({task, dataset_item}, {task, dataset_item, by_human: false, tags: item.tags, confidence: item.confidence}, {upsert: true});
                passed_cnt++;
            }
        }
    }
    task.machine_status = `[${moment().format('YYYY-MM-DD HH:mm')}]` + `学习完毕,上传了${passed_cnt}个数据`;
    await task.save();

    console.log('upload_machine_task', ctx.request.body.data.length, passed_cnt);
    task.machine_running = false;
    await task.save();
    ctx.body = {
        success: true,
        data: {
            total_cnt: ctx.request.body.data.length,
            passed_cnt
        }
    };
});

// task_id, status
router.post('/upload_machine_task_status', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id).populate('dataset');
    assert(task, '参数错误');
    task.machine_status = `[${moment().format('YYYY-MM-DD HH:mm')}]` + ctx.request.body.status;
    task.machine_running = false;
    await task.save();
    ctx.body = {
        success: true
    };
});
