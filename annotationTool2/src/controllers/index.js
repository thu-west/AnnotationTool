require('should');
let Router = require('koa-router');
let auth = require('../services/auth');

const router = module.exports = new Router();

router.get('/ping', async ctx => {
    ctx.body = {
        success: true,
        message: 'pong'
    };
});

router.get('/login_status', async ctx => {
    ctx.body = {
        success: true,
        is_logined: await auth.IsLogined(ctx)
    };
});

// password
router.post('/login', async ctx => {
    await auth.Login(ctx, ctx.request.body.password);
    ctx.body = {
        success: true
    };
});

router.post('/logout', async ctx => {
    await auth.Logout(ctx);
    ctx.body = {
        success: true
    };
});
