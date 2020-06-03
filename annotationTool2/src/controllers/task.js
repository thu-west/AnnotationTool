require('should');
let Router = require('koa-router');
let assert = require('assert');
let { DatasetItem, Task, TaskItem } = require('../models');
let _ = require('lodash');
let auth = require('../services/auth');

const router = module.exports = new Router();

// task_id
router.get('/get_dataset_task', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数非法');
    ctx.body = {
        success: true,
        data: task.toJSON()
    };
});

// task_id
router.post('/set_dataset_task_machine', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');
    task.machine_running = true;
    task.machine_status = '正在等待领取任务';
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, tags: {name, symbol, color}, tag_splits: {title, start, size}, tag_autofit: {symbol, prefix, suffix}
router.post('/set_dataset_task_tags', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');

    let tags = ctx.request.body.tags;
    assert(tags);
    let symbols = new Set();
    for (let t of tags) {
        let name = t.name;
        let symbol = t.symbol;
        let color = t.color;
        assert(name, '实体必须有名称');
        assert(symbol, '实体必须有标签');
        assert(color, '实体必须有对应的颜色');

        assert(symbol.length > 0 && !/\s/.test(symbol), '标签不能有空白');
        assert(symbol !== 'O', '标签不能是O');

        assert(!symbols.has(symbol), `实体符号重复:${symbol}`);
        symbols.add(symbol);
    }

    let tag_splits = ctx.request.body.tag_splits;
    assert(tag_splits);
    let sum = 0;
    for (let s of tag_splits) {
        let title = s.title;
        let start = s.start;
        let size = s.size;
        assert(title, '分栏必须有标签');
        assert(_.isNumber(start), '分栏必须有start');
        assert(_.isNumber(size) && size >= 0, '分栏必须有size');
        assert(start === sum, '分栏错误');
        sum += size;
    }
    assert(sum === tags.length, '分栏数量不一致');

    let tag_autofit = ctx.request.body.tag_autofit;
    assert(_.isArray(tag_autofit));
    let fit_symbols = new Set();
    for (let fit of tag_autofit) {
        assert(_.some(tags, t => t.symbol === fit.symbol), '参数错误');
        assert(!fit_symbols.has(fit.symbol), '参数错误');
        assert(_.has(fit, 'prefix') && _.isString(fit.prefix), '参数错误');
        assert(_.has(fit, 'suffix') && _.isString(fit.suffix), '参数错误');
        fit_symbols.add(fit.symbol);
    }

    task.tags = tags;
    task.tag_splits = tag_splits;
    task.tag_autofit = tag_autofit;
    await task.save();
    ctx.body = {
        success: true
    };
});

// // task_id, name, symbol, color
// router.post('/add_dataset_task_tag', async ctx => {
//     let task = await Task.findById(ctx.request.body.task_id);
//     assert(task, '参数非法');
//     let name = ctx.request.body.name;
//     let symbol = ctx.request.body.symbol;
//     let color = ctx.request.body.color;
//     assert(name, '实体必须有名称');
//     assert(symbol, '实体必须有标签');
//     assert(color, '实体必须有对应的颜色');

//     assert(symbol.length > 0 && !/\s/.test(symbol), '标签不能有空白');
//     assert(symbol !== 'O', '标签不能是O');
//     assert(!_.some(task.tags, t => t.symbol === symbol), '标签已经存在');
//     task.tags.push({name, symbol, color});
//     task.markModified('tags');
//     await task.save();
//     ctx.body = {
//         success: true
//     };
// });

// // task_id, symbol, name, color
// router.post('/modify_dataset_task_tag', async ctx => {
//     let task = await Task.findById(ctx.request.body.task_id);
//     assert(task, '参数非法');
//     let name = ctx.request.body.name;
//     let symbol = ctx.request.body.symbol;
//     let color = ctx.request.body.color;
//     assert(name, '实体必须有名称');
//     assert(symbol, '实体必须有标签');
//     assert(color, '实体必须有对应的颜色');

//     let t = _.find(task.tags, t => t.symbol === symbol);
//     t.name = name;
//     t.color = color;
//     task.markModified('tags');
//     await task.save();
//     ctx.body = {
//         success: true
//     };
// });

// // task_id, symbol
// router.post('/delete_dataset_task_tag', async ctx => {
//     let task = await Task.findById(ctx.request.body.task_id);
//     assert(task, '参数非法');
//     let symbol = ctx.request.body.symbol;
//     assert(symbol, '参数非法');
//     task.tags = task.tags.filter(t => t.symbol !== symbol);
//     await task.save();
//     ctx.body = {
//         success: true
//     };
// });

// // task_id, symbols
// router.post('/reorder_dataset_task_tag', async ctx => {
//     let task = await Task.findById(ctx.request.body.task_id);
//     assert(task, '参数非法');
//     let symbols = ctx.request.body.symbols;
//     assert(symbols, '参数非法');
//     assert(_.isArray(symbols));

//     let tags = [];
//     for (let sym of symbols) {
//         let tag = _.find(task.tags, t => t.symbol === sym);
//         assert(tag);
//         tags.push(tag);
//     }
//     task.tags = tags;

//     await task.save();
//     ctx.body = {
//         success: true
//     };
// });

// task_id, names, relation_autogen: [{entity1s: [], entity2s: [], relation_type, relation_type_text, relation}]
router.post('/set_dataset_task_relation_tags', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.request.body.task_id);
    assert(task, '参数非法');

    let names = ctx.request.body.names;
    assert(_.isArray(names), '参数非法');
    for (let name of names) {
        assert(_.isString(name) && name.length > 0, '参数非法');
    }

    let relation_autogen = ctx.request.body.relation_autogen;
    assert(_.isArray(relation_autogen), '参数非法');
    for (let gen of relation_autogen) {
        assert(_.isObject(gen), '参数非法');
        assert(_.isString(gen.relation_type), '参数非法');
        assert(_.isString(gen.relation_type_text), '参数非法');
        assert(_.isString(gen.relation), '参数非法');
        assert(_.includes(names, gen.relation), '参数非法');

        for (let attr of ['entity1s', 'entity2s']) {
            assert(_.isArray(gen[attr]), '参数非法');
            for (let entity of gen[attr]) {
                assert(_.isObject(entity), '参数错误');
                assert(_.has(entity, 'symbol') && _.has(entity, 'type'), '参数错误');

                assert(_.includes(['all', 'one'], entity.type), '参数错误');
                assert(_.some(task.tags, t => t.symbol === entity.symbol), '参数错误');
            }
        }
    }

    task.relation_tags = names;
    task.relation_autogen = relation_autogen;
    await task.save();
    ctx.body = {
        success: true
    };
});

// task_id, pos?=id number | 'new'
router.get('/get_task_item', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数非法');

    let pos = ctx.query.pos;
    let item = null; // 查询已经存在的item
    if (pos && pos !== 'new') {
        item = await TaskItem.findOne({task, pos, by_human: true}).populate('dataset_item');
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
            curr_pos: item.pos,
            next_pos,
            prev_pos
        };
    } else {
        let banned_items = (await TaskItem.find({task}).select('dataset_item')).map(i => i.dataset_item.toString());
        let dataset_item = await DatasetItem.findOne({dataset: task.dataset, _id: {$not: {$in: banned_items}}});
        if (dataset_item) {
            let next_pos = null;
            let prev_pos = null;
            let curr_pos = null;

            let count = await TaskItem.countDocuments({task: task, by_human: true, pos: {$exists: true}});
            if (count > 0) {
                let max_id = (await TaskItem.findOne({task: task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
                prev_pos = max_id;
                curr_pos = max_id + 1;
            } else {
                curr_pos = 1;
            }

            task_info = {
                dataset_item: dataset_item._id,
                content: dataset_item.content,
                tags: [{length: dataset_item.content.length, symbol: 'O', text: dataset_item.content}],
                relation_tags: [],
                confidence: 0,
                by_human: false,
                curr_pos,
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
                curr_pos: null,
                prev_pos,
                next_pos: null
            };
        }
    }
    let count = await TaskItem.countDocuments({task: task, by_human: true, pos: {$exists: true}});
    if (count > 0) {
        let max_id = (await TaskItem.findOne({task: task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
        task_info.num_pos = max_id;
    } else {
        task_info.num_pos = 0;
    }

    ctx.body = {
        success: true,
        data: task_info
    };
});
// task_id, dataset_item_id, tags, relation_tags
router.post('/set_task_item_tags', auth.LoginRequired, async ctx => {
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
        assert(_.has(tag, 'text') && _.isString(tag.text), '参数错误');
        assert(_.keys(tag).length === 3, '参数错误');
        sum_length += tag.length;
    }
    assert(sum_length === dataset_item.content.length, '总长度不正确');

    let relation_tags = ctx.request.body.relation_tags || [];
    assert(_.isArray(relation_tags), '参数错误');
    for (let r of relation_tags) {
        assert(_.isArray(r.entity1), '参数错误');
        assert(_.isArray(r.entity2), '参数错误');
        assert(r.entity1.length > 0, '参数错误');
        assert(r.entity2.length > 0, '参数错误');
        for (let i = 0; i < 2; i++) {
            if (r.relation_type.split('2')[i] === 'one' && r[`entity${i + 1}`].length > 1) {
                assert(false, '参数错误');
            }
        }
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
router.get('/download_task_triple', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数错误');

    let data = [];

    let entity_symbol2type = new Map(); // symbol -> name
    for (let t of task.tags) {
        let name = `${t.name}(${t.symbol})`;
        assert(!entity_symbol2type.has(t.symbol), '标注错误1');
        entity_symbol2type.set(t.symbol, name);
    }

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

                    this_texts.push({text, symbol: entity_symbol2type.get(symbol)});
                }
                pairs.push(this_texts);
            }
            if (pairs.length === 2 && pairs[0].length > 0 && pairs[1].length > 0) {
                for (let p1 of pairs[0]) {
                    for (let p2 of pairs[1]) {
                        data.push({
                            text: item.dataset_item.content,
                            schema: [p1.symbol, r.relation, p2.symbol],
                            triples: [p1.text, r.relation, p2.text, r.relation_type_text]
                        });
                    }
                }
            }
        }
    }

    ctx.set('Content-Disposition', 'attachment; filename="triple.json"');
    ctx.body = JSON.stringify(data, null, 4);
});

// task_id
router.get('/download_task_triple_std', auth.LoginRequired, async ctx => {
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
                    // assert(symbol !== null && symbol !== 'O', '标注错误2');
                    if (symbol !== null && symbol !== 'O') {
                        console.warn('标注错误2');
                        continue;
                    }
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
                if (this_texts.length === 0) {
                    console.warn('空关系实体');
                    continue;
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
                } else if (r.relation_type === 'many2many') {
                    let v0 = `${entity_id}:${r.relation_type_text}:part1`;
                    entity_id++;
                    let v1 = `${entity_id}:${r.relation_type_text}:part2`;
                    entity_id++;
                    triples.push([v0, r.relation, v1]);

                    for (let n of pairs[0]) {
                        triples.push([
                            n,
                            'one_of',
                            v0
                        ]);
                    }
                    for (let n of pairs[1]) {
                        triples.push([
                            v1,
                            'one_of',
                            n
                        ]);
                    }
                } else {
                    assert(false, '标注错误6');
                }
            }
        }
    }

    ctx.set('Content-Disposition', 'attachment; filename="triple_std.txt"');
    let lines = [];
    for (let tri of triples) {
        lines.push('<' + tri[0] + '>');
        lines.push('<' + tri[1] + '>');
        lines.push('<' + tri[2] + '> .');
        lines.push('');
    }
    if (lines.length > 0) {
        lines.pop();
    }
    ctx.body = lines.join('\n');
});

// task_id
router.get('/download_task_entities', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数错误');

    let entities = [];

    for (let item of await TaskItem.find({task, by_human: true}).populate('dataset_item')) {
        let symbols = {};
        let start = 0;
        for (let t of item.tags) {
            if (!symbols[t.symbol]) {
                symbols[t.symbol] = [];
            }
            symbols[t.symbol].push({
                start,
                end: start + t.length,
                text: t.text
            });
            start += t.length;
        }
        assert(start === item.dataset_item.content.length);

        let names = {};
        for (let t of task.tags) {
            names[t.name] = symbols[t.symbol] || [];
        }
        entities.push({
            text: item.dataset_item.content,
            entities: names
        });
    }

    ctx.set('Content-Disposition', 'attachment; filename="entities.json"');
    ctx.body = JSON.stringify(entities, null, 4);
});

// task_id
router.get('/get_task_summary', auth.LoginRequired, async ctx => {
    let task = await Task.findById(ctx.query.task_id).populate('dataset');
    assert(task, '参数错误');

    let tags = task.tags;
    let entity_tags = {};
    let relation_tags = [];

    for (let t of tags) {
        entity_tags[t.symbol] = [];
    }

    for (let item of await TaskItem.find({task, by_human: true}).populate('dataset_item')) {
        for (let t of item.tags) {
            if (_.has(entity_tags, t.symbol)) {
                entity_tags[t.symbol].push(t.text);
            }
        }
        relation_tags = _.concat(relation_tags, item.relation_tags);
    }

    for (let t of tags) {
        entity_tags[t.name] = _.uniq(entity_tags[t.name]);
    }

    ctx.body = {
        success: true,
        tags,
        entity_tags,
        relation_tags
    };
});
