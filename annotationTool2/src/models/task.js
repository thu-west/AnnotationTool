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
    tag_splits: { // 分栏
        type: [
            {
                title: {type: String, required: true},
                start: {type: Number, required: true},
                size: {type: Number, required: true}
            }
        ],
        required: true,
        default: []
    },
    tag_autofit: { // 自动填充
        type: [
            {
                symbol: {type: String, required: true},
                prefix: String,
                suffix: String
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
    relation_autogen: { // 关系自动生成
        type: [
            {
                entity1s: [
                    {
                        symbol: {type: String, required: true},
                        type: {type: String, required: true} // 类型, all | one
                    }
                ],
                entity2s: [
                    {
                        symbol: {type: String, required: true},
                        type: {type: String, required: true} // 类型, all | one
                    }
                ],
                relation_type: String, // one2one, one2many, many2one
                relation_type_text: String, // 一对一, 一对多_和 ...
                relation: String
            }
        ],
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
