let path = require('path');
let mzfs = require('mz/fs');
let config = require('../config');
let _ = require('lodash');
let { DatasetItem } = require('../models');

// return {insertable: Boolean, message: String, items: Array of Object}
exports.datafileAnalysis = async (dataset, fileid_or_filename) => {
    let insertable = true;
    let items = [];

    // 严重错误
    let json_error = false; // JSON格式错误
    let empty_id = false; // id为空
    let trim_id = false; // id是否存在两边空白

    // 警告
    let json_redundant_prop = false; // 是否存在对象有额外的属性
    let self_repeat = 0; // 自己ID重复的数量
    let dataset_repeat = 0; // 和数据库ID重复
    let empty_content = 0; // 内容空白

    let filepath = fileid_or_filename;
    if (/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(fileid_or_filename)) {
        filepath = path.join(config.FILE_PATH, fileid_or_filename);
    }
    let content = await mzfs.readFile(filepath);
    let data = null;
    try {
        data = JSON.parse(content);
    } catch (e) {
        json_error = true;
        insertable = false;
    }
    if (data) {
        if (!_.isArray(data) || _.some(data, i => !_.isObject(i))) {
            json_error = true;
            insertable = false;
        } else {
            let old_ids = new Set();
            for (let i = 0, batch_size = 1024; ; i++) {
                let ids = await DatasetItem.find({ dataset }).skip(i * batch_size).limit(batch_size).select('id');
                if (ids.length === 0) break;
                for (let id of ids) {
                    old_ids.add(id.id);
                }
            }

            let ids = new Set();
            for (let item of data) {
                if (!_.has(item, 'id') || !_.has(item, 'content') || !_.isString(item.id) || !_.isString(item.content)) {
                    json_error = true;
                    insertable = false;
                } else {
                    if (_.keys(item).length > 2) {
                        json_redundant_prop = true;
                    }
                    let id = item.id;
                    let content = item.content;
                    if (id.trim().length === 0) {
                        empty_id = true;
                        insertable = false;
                    }
                    if (id.trim() !== id) {
                        trim_id = true;
                        insertable = false;
                    }
                    if (ids.has(id)) {
                        self_repeat++;
                    } else {
                        ids.add(id);
                    }
                    if (old_ids.has(id)) {
                        dataset_repeat++;
                    }
                    if (content.trim().length === 0) {
                        empty_content++;
                    }
                }
                items.push(_.pick(item, ['id', 'content']));
            }
        }
    }

    let messages = [];
    if (json_error) {
        messages.push('JSON格式错误');
    } else if (empty_id) {
        messages.push('存在ID为空白');
    } else if (trim_id) {
        messages.push('一些ID的前后存在空白字符');
    } else {
        if (json_redundant_prop) {
            messages.push('存在一些对象有id和content以外的属性');
        }
        if (self_repeat) {
            messages.push(`上传的数据中有${self_repeat}个数据的ID重复了`);
        }
        if (dataset_repeat) {
            messages.push(`上传的数据中有${dataset_repeat}个数据的ID和数据库中的已有数据重复`);
        }
        if (empty_content) {
            messages.push('存在content为空白的情况');
        }
    }
    let message = null;
    if (messages.length > 0) {
        message = JSON.stringify(messages);
    }

    return { insertable, items, message };
};
