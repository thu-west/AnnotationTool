let mongoose = require('mongoose');
let config = require('../config');

mongoose.Promise = global.Promise;

exports.Dataset = require('./dataset');
exports.DatasetItem = require('./dataset_item');
exports.Task = require('./task');
exports.TaskItem = require('./task_item');

mongoose.connect(config.MONGODB_URL, {
    useNewUrlParser: true
}, function (err) {
    if (err) {
        console.error('connect to %s error: ', config.MONGODB_URL, err.message);
        process.exit(1);
    }
});
