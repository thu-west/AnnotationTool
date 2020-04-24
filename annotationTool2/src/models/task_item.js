let mongoose = require('mongoose');

// 标注任务数据
let taskItemSchema = new mongoose.Schema({
    task: {
        type: mongoose.Schema.ObjectId,
        ref: 'Task',
        required: true,
        index: true
    },
    dataset_item: {
        type: mongoose.Schema.ObjectId,
        ref: 'DatasetItem',
        required: true,
        index: true
    },

    // 标注数据
    tags: {
        type: [{ // tags是依次排开的，length之和必须和原文本长度之和相同
            length: {type: Number, required: true},
            symbol: {type: String, required: true},
            text: {type: String, required: true}
        }],
        required: true,
        default: []
    },

    relation_tags: {
        type: [
            {
                entity1: [{
                    start_pos: Number,
                    end_pos: Number,
                    text: String
                }],
                relation_type: String, // one2one, one2many, many2one
                relation_type_text: String, // 一对一, 一对多_和 ...
                relation: String,
                entity2: [{
                    start_pos: Number,
                    end_pos: Number,
                    text: String
                }],
                support_text: String // 可选
            }
        ],
        required: true,
        default: []
    },

    pos: Number, // 标注顺序，从1开始
    confidence: { // 信心
        type: Number,
        required: true,
        default: 0
    },
    by_human: { // 是否是人标注的
        type: Boolean,
        required: true,
        default: false
    },

    created_date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('TaskItem', taskItemSchema);
