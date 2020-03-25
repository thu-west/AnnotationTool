let Router = require('koa-router');
require('should');

const router = module.exports = new Router();

router.get('/ping', async ctx => {
    ctx.body = {
        success: true,
        message: 'pong'
    };
});
