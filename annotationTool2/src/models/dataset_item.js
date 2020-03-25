let mongoose = require('mongoose');

// 数据集数据
let datasetItemSchema = new mongoose.Schema({
    dataset: { // 所属的数据集
        type: mongoose.Schema.ObjectId,
        ref: 'Dataset',
        required: true,
        index: true
    },
    id: { // 数据的ID，和_id并不相同，用于导入导出
        type: String,
        index: true,
        required: true
    },
    content: {
        type: String,
        required: true
    },

    created_date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('DatasetItem', datasetItemSchema);
