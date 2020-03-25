let { Dataset, DatasetItem } = require('../src/models');
let utils = require('../src/services/utils');
let prompts = require('prompts');
let assert = require('assert');
let _ = require('lodash');

// 插入数据
async function main(datafile) {
    let datasets = await Dataset.find({is_deleted: false});
    console.log('Select a dataset to insert data');
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
    let analysis = await utils.datafileAnalysis(dataset, datafile);
    if (!analysis.insertable) {
        console.log('Not insertable:', analysis.message);
        return;
    }
    console.log(`Total ${analysis.items.length} items.`);
    if (analysis.message) {
        console.log('Some warnings:', analysis.message);
        let { value : yn } = await prompts({
            type: 'text',
            name: 'value',
            message: 'Still insert data(yes/no)?'
        });
        if (yn !== 'yes') return;
    } else {
        let { value : yn } = await prompts({
            type: 'text',
            name: 'value',
            message: 'Insert data(yes/no)?'
        });
        if (yn !== 'yes') return;
    }

    for (let i = 0, batch_size = 1024; ; i++) {
        let items = analysis.items.slice(i * batch_size, i * batch_size + batch_size);
        if (items.length === 0) break;
        for (let item of items) item.dataset = dataset._id;
        await DatasetItem.create(items);
    }
    console.log('Insert success.');
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
