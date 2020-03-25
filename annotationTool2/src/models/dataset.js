let mongoose = require('mongoose');

// 数据集
let datasetSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true
    },
    description: String,

    is_deleted: { // 是否被删除
        type: Boolean,
        required: true,
        default: false
    },
    created_date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Dataset', datasetSchema);
