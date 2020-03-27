require('should');
let Router = require('koa-router');
let assert = require('assert');
let { Dataset, DatasetItem, Task, TaskItem } = require('../models');
let config = require('../config');
let body = require('koa-body');
let mzfs = require('mz/fs');
let path = require('path');
let uuidv1 = require('uuid/v1');
let utils = require('../services/utils');

const router = module.exports = new Router();

// title, description
router.post('/create_dataset', async ctx => {
    let {title, description} = ctx.request.body;
    assert(title, '必须有数据集标题');
    await Dataset.create({title, description});
    ctx.body = {
        success: true
    };
});

// dataset_id, title, description
router.post('/update_dataset', async ctx => {
    let {title, description} = ctx.request.body;
    assert(title, '必须有数据集标题');
    let dataset = await Dataset.findById(ctx.request.body.dataset_id);
    assert(dataset, '数据集不存在');
    dataset.title = title;
    dataset.description = description;
    await dataset.save();
    ctx.body = {
        success: true
    };
});

// dataset_id
router.post('/delete_dataset', async ctx => {
    let dataset = await Dataset.findById(ctx.request.body.dataset_id);
    assert(dataset, '数据集不存在');
    dataset.is_deleted = true;
    await dataset.save();
    ctx.body = {
        success: true
    };
});

router.get('/list_dataset', async ctx => {
    let datasets = await Dataset.find({is_deleted: false}).sort('-_id');
    datasets = datasets.map(d => d.toJSON());
    for (let dataset of datasets) {
        dataset.item_num = await DatasetItem.count({dataset: dataset._id});
    }
    ctx.body = {
        success: true,
        data: datasets
    };
});

// dataset_id
router.get('/get_dataset', async ctx => {
    let dataset = await Dataset.findById(ctx.query.dataset_id);
    dataset = dataset.toJSON();
    dataset.item_num = await DatasetItem.count({dataset: dataset._id});
    dataset.tasks = (await Task.find({dataset, is_deleted: false})).map(i => i.toJSON());
    for (let task of dataset.tasks) {
        task.passed_num = await TaskItem.count({task: task._id, by_human: true});
    }
    ctx.body = {
        success: true,
        data: dataset
    };
});

// 上传数据, JSON格式，[{id: String, content: String}]
// data, dataset_id
router.post('/insert_dataset', body({multipart: true}), async ctx => {
    let dataset = await Dataset.findById(ctx.request.body.dataset_id);
    assert(dataset, '参数非法');
    let datafile = ctx.request.files.datafile;
    assert(datafile, '没有找到上传的文件');
    let fileid = uuidv1();
    // await mzfs.rename(datafile.path, path.join(config.FILE_PATH, fileid));
    await mzfs.copyFile(datafile.path, path.join(config.FILE_PATH, fileid));
    let analysis = await utils.datafileAnalysis(dataset, fileid);
    ctx.body = {
        success: true,
        data: {
            fileid,
            insertable: analysis.insertable,
            message: analysis.message
        }
    };
});
// fileid, dataset_id
router.post('/insert_dataset_confirm', async ctx => {
    let dataset = await Dataset.findById(ctx.request.body.dataset_id);
    assert(dataset, '参数非法');
    let fileid = ctx.request.body.fileid;
    assert(fileid, '参数非法');
    let analysis = await utils.datafileAnalysis(dataset, fileid);
    assert(analysis.insertable, '此数据是不可添加的');
    for (let i = 0, batch_size = 1024; ; i++) {
        let items = analysis.items.slice(i * batch_size, i * batch_size + batch_size);
        if (items.length === 0) break;
        for (let item of items) item.dataset = dataset._id;
        await DatasetItem.create(items);
    }
    ctx.body = {
        success: true
    };
});

// 标注任务

// dataset_id, title
router.post('/create_dataset_task', async ctx => {
    let dataset = await Dataset.findById(ctx.request.body.dataset_id);
    assert(dataset, '参数非法');
    let title = ctx.request.body.title;
    assert(title, '标注任务的名称必填');
    await Task.create({dataset, title});
    ctx.body = {
        success: true
    };
});

// task_id
router.post('/delete_dataset_task', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    task.is_deleted = true;
    await task.save();
    ctx.body = {
        success: true
    };
});
