let { Dataset, DatasetItem, Task, TaskItem } = require('../src/models');
let utils = require('../src/services/utils');
let prompts = require('prompts');
let assert = require('assert');
let _ = require('lodash');
let fs = require('fs');

// 插入标注
async function main(labelfile) {
    let datasets = await Dataset.find({is_deleted: false});
    console.log('Select a dataset to insert labels');
    for(let i = 0; i < datasets.length; i ++) {
        console.log(`${i}. ${datasets[i].title}`);
    }
    let { value : idx } = await prompts({
        type: 'number',
        name: 'value',
        message: 'Input dataset number:',
        validate: value => 0 <= value && value < datasets.length ? true : 'Wrong number'
    });
    assert(_.isNumber(idx));
    let dataset = datasets[idx];

    let tasks = await Task.find({is_deleted: false, dataset});
    console.log('Select a task to insert labels');
    for(let i = 0; i < tasks.length; i ++) {
        console.log(`${i}. ${tasks[i].title}`);
    }
    let { value : lidx } = await prompts({
        type: 'number',
        name: 'value',
        message: 'Input task number:',
        validate: value => 0 <= value && value < tasks.length ? true : 'Wrong number'
    });
    assert(_.isNumber(lidx));
    let task = tasks[lidx];

    let content = fs.readFileSync(labelfile, 'utf-8');
    let labels = JSON.parse(content);
    let passed_cnt = 0;
    for(let i = 0; i < labels.length; i ++) {
        let dataset_item = await DatasetItem.findOne({dataset, id: labels[i].id});
        if (dataset_item) {
            await TaskItem.findOneAndUpdate({task, dataset_item}, {task, dataset_item, tags: labels[i].tags, by_human: true}, {upsert: true});
            passed_cnt ++;
        }
    }
    console.log(`Total ${labels.length} labels, success inserted ${passed_cnt} labels.`);
}

(async () => {
    try {
        if (process.argv.length <= 2) {
            console.log(`usage: node ${process.argv[1]} datafile`);
            return;
        }
        await main(process.argv[2]);
        process.exit(0);
    } catch (e) {
        console.error(e);
        process.exit(1);
    }
})();
