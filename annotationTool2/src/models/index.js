let mongoose = require('mongoose');
let config = require('../config');

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
