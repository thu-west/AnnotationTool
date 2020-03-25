import axios from 'axios';
import { Modal, LoadingBar } from 'view-design';

const baseURL = '/api/';

let instance = axios.create({
    baseURL: baseURL,
    timeout: 10000
});

function showModel (type, title, content) {
    return new Promise((resolve) => {
        setTimeout(() => {
            Modal[type]({
                title: title,
                content: content,
                onOk: resolve
            });
        }, 500);
    });
}

function never () {
    return new Promise(() => {});
}

async function handle (req, { nocheck = false, use_loading = false, plain = false } = {}) {
    let data = {};
    try {
        if (use_loading) LoadingBar.start();
        let res = await req;
        data = res.data;
    } catch (e) {
        if (!nocheck) await showModel('error', '网络错误', e.message);
        if (use_loading) LoadingBar.finish();
        // throw e; // IE上会弹出错误提示
        await never();
    }
    if (!data.success) {
        if (!nocheck) await showModel('info', '错误', data.message);
        if (use_loading) LoadingBar.finish();
        // throw new Error(data.message);
        await never();
    }
    if (use_loading) LoadingBar.finish();
    return data;
}

let exp = {};
export default exp;

exp.baseURL = baseURL;

exp.get = async function (url, params) {
    params = params || {};
    if (!params.hasOwnProperty('r')) params.r = Math.random();
    return await handle(instance.get(url, { params }));
};

exp.get_loading = async function (url, params) {
    params = params || {};
    if (!params.hasOwnProperty('r')) params.r = Math.random();
    return await handle(instance.get(url, { params }), { use_loading: true });
};

exp.get_nocheck = async function (url, params) {
    params = params || {};
    if (!params.hasOwnProperty('r')) params.r = Math.random();
    return await handle(instance.get(url, { params }), { nocheck: true });
};

exp.post = async function (url, params, data) {
    params = params || {};
    data = data || {};
    if (!params.hasOwnProperty('r')) params.r = Math.random();
    return await handle(instance.post(url, data, { params }));
};

exp.post_loading = async function (url, params, data) {
    params = params || {};
    data = data || {};
    if (!params.hasOwnProperty('r')) params.r = Math.random();
    return await handle(instance.post(url, data, { params }), { use_loading: true });
};
