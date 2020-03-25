let mongoose = require('mongoose');

// 数据集标注任务
let taskSchema = new mongoose.Schema({
    dataset: { // 标注任务所属的数据集
        type: mongoose.Schema.ObjectId,
        ref: 'Dataset',
        required: true,
        index: true
    },

    title: {
        type: String,
        required: true
    },
    tags: { // 这个任务的实体标签列表
        type: [
            {
                name: {type: String, required: true},
                symbol: {type: String, required: true}, // 符号，O有特殊含义，保留
                color: {type: String, required: true}
            }
        ],
        required: true,
        default: []
    },
    relation_tags: { // 关系标签列表
        type: [String],
        required: true,
        default: []
    },

    machine_running: {
        type: Boolean,
        required: true,
        default: false
    },
    machine_status: String,

    is_deleted: { // 是否被删除
        type: Boolean,
        required: true,
        default: false
    },
    created_date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Task', taskSchema);
