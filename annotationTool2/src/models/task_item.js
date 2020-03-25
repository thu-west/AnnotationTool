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

    tags: {
        type: [{ // tags是依次排开的，length之和必须和原文本长度之和相同
            length: {type: Number, required: true},
            symbol: {type: String, required: true}
        }],
        required: true,
        default: []
    },

    relation_tags: {
        type: [
            {
                entity1: {
                    start_pos: Number,
                    end_pos: Number,
                    text: String
                },
                relation: String,
                entity1: {
                    start_pos: Number,
                    end_pos: Number,
                    text: String
                },
                support_text: String // 可选
            }
        ]
    },

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
