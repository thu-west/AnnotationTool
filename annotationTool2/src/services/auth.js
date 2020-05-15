
let config = require('../config');
let utility = require('utility');
let assert = require('assert');

exports.authM = async (ctx, next) => {
    if (ctx.session.password_sha256 && ctx.session.password_sha256 === utility.sha256(config.PASSWORD)) {
        ctx.state.logined = true;
    }
    await next();
};

exports.LoginRequired = async (ctx, next) => {
    assert(ctx.state.logined, '尚未登录');
    await next();
};

exports.IsLogined = async (ctx) => {
    return ctx.state.logined;
};

exports.Login = async (ctx, password) => {
    assert(password && password === config.PASSWORD, '密码错误');
    ctx.session.password_sha256 = utility.sha256(password);
};

exports.Logout = async (ctx) => {
    ctx.session.password_sha256 = null;
};
