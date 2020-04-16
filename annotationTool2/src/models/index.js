let mongoose = require('mongoose');
let config = require('../config');
let _ = require('lodash');

mongoose.Promise = global.Promise;

exports.Dataset = require('./dataset');
exports.DatasetItem = require('./dataset_item');
exports.Task = require('./task');
let TaskItem = exports.TaskItem = require('./task_item');

async function buildID () {
    // await TaskItem.collection.update({}, {$unset: {pos: 1 }}, {multi: true});
    while (true) {
        let item = await TaskItem.findOne({by_human: true, pos: {$exists: false}});
        if (!item) break;
        let count = await TaskItem.countDocuments({task: item.task, by_human: true, pos: {$exists: true}});
        if (count > 0) {
            let max_id = (await TaskItem.findOne({task: item.task, by_human: true, pos: {$exists: true}}).sort('-pos')).pos;
            item.pos = max_id + 1;
        } else {
            item.pos = 1;
        }
        console.log(item.pos);
        await item.save();
    }

    for (let skip = 0; ;skip++) {
        let item = await TaskItem.findOne({ 'relation_tags.0': { '$exists': true } }).skip(skip).populate('task');
        if (!item) break;

        for (let r of item.relation_tags) {
            if (!r.relation_type) {
                r.relation_type = 'one2one';
                r.relation_type_text = '一对一';
            }
            if (!_.isArray(r.entity1)) {
                r.entity1 = [r.entity1];
            }
            if (!_.isArray(r.entity2)) {
                r.entity2 = [r.entity2];
            }
        }
        item.markModified('relation_tags');
        await item.save();
    }
    console.log('rebuild db success');
}

mongoose.connect(config.MONGODB_URL, {
    useNewUrlParser: true
}, function (err) {
    if (err) {
        console.error('connect to %s error: ', config.MONGODB_URL, err.message);
        process.exit(1);
    } else {
        buildID();
    }
});
