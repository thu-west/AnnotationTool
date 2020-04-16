require('should');
let Router = require('koa-router');
let assert = require('assert');
let { DatasetItem, Task, TaskItem } = require('../models');
let _ = require('lodash');

const router = module.exports = new Router();

// task_id
router.get('/get_dataset_task', async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数非法');
    ctx.body = {
        success: true,
        data: task.toJSON()
    };
});

// task_id
router.post('/set_dataset_task_machine', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    task.machine_running = true;
    task.machine_status = '正在等待领取任务';
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, name, symbol, color
router.post('/add_dataset_task_tag', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    let name = ctx.request.body.name;
    let symbol = ctx.request.body.symbol;
    let color = ctx.request.body.color;
    assert(name, '实体必须有名称');
    assert(symbol, '实体必须有标签');
    assert(color, '实体必须有对应的颜色');

    assert(symbol.length > 0 && !/\s/.test(symbol), '标签不能有空白');
    assert(symbol !== 'O', '标签不能是O');
    assert(!_.some(task.tags, t => t.symbol === symbol), '标签已经存在');
    task.tags.push({name, symbol, color});
    task.markModified('tags');
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, symbol, name, color
router.post('/modify_dataset_task_tag', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    let name = ctx.request.body.name;
    let symbol = ctx.request.body.symbol;
    let color = ctx.request.body.color;
    assert(name, '实体必须有名称');
    assert(symbol, '实体必须有标签');
    assert(color, '实体必须有对应的颜色');

    let t = _.find(task.tags, t => t.symbol === symbol);
    t.name = name;
    t.color = color;
    task.markModified('tags');
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, symbol
router.post('/delete_dataset_task_tag', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    let symbol = ctx.request.body.symbol;
    assert(symbol, '参数非法');
    task.tags = task.tags.filter(t => t.symbol !== symbol);
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, symbols
router.post('/reorder_dataset_task_tag', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    let symbols = ctx.request.body.symbols;
    assert(symbols, '参数非法');
    assert(_.isArray(symbols));

    let tags = [];
    for (let sym of symbols) {
        let tag = _.find(task.tags, t => t.symbol === sym);
        assert(tag);
        tags.push(tag);
    }
    task.tags = tags;

    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, names
router.post('/set_dataset_task_relation_tag', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    let names = ctx.request.body.names;
    assert(_.isArray(names), '参数非法');
    task.relation_tags = names;
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, pos?=id number | 'new'
router.get('/get_task_item', async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数非法');

    let pos = ctx.query.pos;
    let item = null; // 查询已经存在的item
    if (pos && pos !== 'new') {
        item = await TaskItem.findOne({task, pos}).populate('dataset_item');
        assert(item, '参数错误');
    } else {
        item = await TaskItem.findOne({task, by_human: false}).sort('confidence').populate('dataset_item');
    }

    if (item && !item.pos) {
        let count = await TaskItem.countDocuments({task: item.task, by_human: true, pos: {$exists: true}});
        if (count > 0) {
            let max_id = (await TaskItem.findOne({task: item.task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
            item.pos = max_id + 1;
        } else {
            item.pos = 1;
        }
    }

    let task_info = null;
    if (item) {
        let next_pos = null;
        let prev_pos = null;

        if (await TaskItem.findOne({task: item.task, pos: item.pos - 1})) {
            prev_pos = item.pos - 1;
        }
        if (await TaskItem.findOne({task: item.task, pos: item.pos + 1})) {
            next_pos = item.pos + 1;
        } else if (await TaskItem.findOne({task: item.task, pos: item.pos})) {
            next_pos = 'new';
        }

        task_info = {
            dataset_item: item.dataset_item._id,
            content: item.dataset_item.content,
            tags: item.tags,
            relation_tags: item.relation_tags,
            confidence: item.confidence,
            by_human: item.by_human,
            next_pos,
            prev_pos
        };
    } else {
        let banned_items = (await TaskItem.find({task}).select('dataset_item')).map(i => i.dataset_item.toString());
        let dataset_item = await DatasetItem.findOne({dataset: task.dataset, _id: {$not: {$in: banned_items}}});
        if (dataset_item) {
            let next_pos = null;
            let prev_pos = null;

            let count = await TaskItem.countDocuments({task: task, by_human: true, pos: {$exists: true}});
            if (count > 0) {
                let max_id = (await TaskItem.findOne({task: task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
                prev_pos = max_id;
            }

            task_info = {
                dataset_item: dataset_item._id,
                content: dataset_item.content,
                tags: [{length: dataset_item.content.length, symbol: 'O'}],
                relation_tags: [],
                confidence: 0,
                by_human: false,
                next_pos,
                prev_pos
            };
        } else {
            let prev_pos = null;

            let count = await TaskItem.countDocuments({task: task, by_human: true, pos: {$exists: true}});
            if (count > 0) {
                let max_id = (await TaskItem.findOne({task: task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
                prev_pos = max_id;
            }
            task_info = {
                prev_pos,
                next_pos: null
            };
        }
    }

    ctx.body = {
        success: true,
        data: task_info
    };
});
// task_id, dataset_item_id, tags, relation_tags
router.post('/set_task_item_tags', async ctx => {
    let task = await Task.findById(ctx.request.body.task_id).populate('dataset');
    assert(task, '参数错误');
    let dataset_item = await DatasetItem.findById(ctx.request.body.dataset_item_id).populate('dataset');
    assert(dataset_item, '参数错误');
    assert(task.dataset._id.equals(dataset_item.dataset._id), '参数错误');

    let tags = ctx.request.body.tags;
    assert(_.isArray(tags), '参数错误');
    let sum_length = 0;
    for (let tag of tags) {
        assert(_.isObject(tag), '参数错误');
        assert(_.has(tag, 'length') && _.isNumber(tag.length) && tag.length > 0, '参数错误');
        assert(_.has(tag, 'symbol') && _.isString(tag.symbol) && (tag.symbol === 'O' || _.some(task.tags, i => i.symbol === tag.symbol)), '参数错误');
        assert(_.keys(tag).length === 2, '参数错误');
        sum_length += tag.length;
    }
    assert(sum_length === dataset_item.content.length, '总长度不正确');

    let relation_tags = ctx.request.body.relation_tags || [];
    assert(_.isArray(relation_tags), '参数错误');
    for (let r of relation_tags) {
        assert(_.isArray(r.entity1), '参数错误');
        assert(_.isArray(r.entity2), '参数错误');
        assert(_.isString(r.relation_type) && r.relation_type, '参数错误');
        assert(_.isString(r.relation_type_text) && r.relation_type_text, '参数错误');
        assert(_.isString(r.relation) && r.relation, '参数错误');
    }

    let pos = -1;

    let task_item = await TaskItem.findOne({task, dataset_item});
    if (task_item) {
        pos = task_item.pos;
    } else {
        let count = await TaskItem.countDocuments({task: task, by_human: true, pos: {$exists: true}});
        if (count > 0) {
            let max_id = (await TaskItem.findOne({task: task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
            pos = max_id + 1;
        } else {
            pos = 1;
        }
    }
    assert(pos >= 1);

    await TaskItem.findOneAndUpdate({task, dataset_item}, {task, dataset_item, pos, tags, relation_tags, by_human: true}, {upsert: true});
    ctx.body = {
        success: true
    };
});

// task_id
router.get('/download_task_triple', async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数错误');

    let instance_of = {};
    let triples = [];

    let entity_id = 0;

    let entity_type_map = new Map(); // name -> id
    let entity_symbol2type = new Map(); // symbol -> name
    for (let t of task.tags) {
        let name = `${t.name}(${t.symbol})`;
        assert(!entity_type_map.has(name), '标注错误0');
        assert(!entity_symbol2type.has(t.symbol), '标注错误1');
        entity_symbol2type.set(t.symbol, name);
        entity_type_map.set(name, entity_id);
        entity_id++;
    }

    let entity_text_map = new Map(); // text -> id
    let entity_text_printed = new Set(); // text|symbol
    for (let item of await TaskItem.find({task, by_human: true}).populate('dataset_item')) {
        for (let r of item.relation_tags) {
            let pairs = [];
            for (let entities of [r.entity1, r.entity2]) {
                let this_texts = [];
                for (let entity of entities) {
                    let text = entity.text;

                    let start = 0;
                    let symbol = null;
                    for (let t of item.tags) {
                        if (start === entity.start_pos && t.length === entity.end_pos - entity.start_pos) {
                            symbol = t.symbol;
                        }
                        start += t.length;
                    }
                    assert(symbol !== null && symbol !== 'O', '标注错误2');
                    if (!entity_symbol2type.has(symbol)) continue;

                    if (!entity_text_map.has(text)) {
                        entity_text_map.set(text, entity_id);
                        entity_id++;
                    }

                    if (!entity_text_printed.has(text + '|' + symbol)) {
                        entity_text_printed.add(text + '|' + symbol);

                        triples.push([
                            `${entity_text_map.get(text)}:${text}`,
                            'is_an_instance_of',
                            `${entity_type_map.get(entity_symbol2type.get(symbol))}:${entity_symbol2type.get(symbol)}`
                        ]);
                        if (!_.has(instance_of, `${entity_type_map.get(entity_symbol2type.get(symbol))}:${entity_symbol2type.get(symbol)}`)) {
                            instance_of[`${entity_type_map.get(entity_symbol2type.get(symbol))}:${entity_symbol2type.get(symbol)}`] = [];
                        }
                        instance_of[`${entity_type_map.get(entity_symbol2type.get(symbol))}:${entity_symbol2type.get(symbol)}`].push(`${entity_text_map.get(text)}:${text}`);
                    }

                    this_texts.push(`${entity_text_map.get(text)}:${text}`);
                }
                pairs.push(this_texts);
            }
            if (pairs.length === 2 && pairs[0].length > 0 && pairs[1].length > 0) {
                if (r.relation_type === 'one2one') {
                    assert(pairs[0].length === 1 && pairs[1].length === 1, '标注错误3');
                    triples.push([
                        pairs[0][0],
                        r.relation,
                        pairs[1][0]
                    ]);
                } else if (r.relation_type === 'one2many') {
                    assert(pairs[0].length === 1, '标注错误4');
                    let v = `${entity_id}:${r.relation_type_text}`;
                    entity_id++;
                    triples.push([
                        pairs[0][0],
                        r.relation,
                        v
                    ]);
                    for (let n of pairs[1]) {
                        triples.push([
                            v,
                            'has_a',
                            n
                        ]);
                    }
                } else if (r.relation_type === 'many2one') {
                    assert(pairs[1].length === 1, '标注错误5');
                    let v = `${entity_id}:${r.relation_type_text}`;
                    entity_id++;
                    for (let n of pairs[0]) {
                        triples.push([
                            n,
                            'is_a',
                            v
                        ]);
                    }
                    triples.push([
                        v,
                        r.relation,
                        pairs[1][0]
                    ]);
                } else {
                    assert(false, '标注错误6');
                }
            }
        }
    }

    ctx.set('Content-Disposition', 'attachment; filename="download.json"');
    ctx.body = JSON.stringify({instance_of, triples}, null, 4);
});
