<template>
    <div class="main">
        <Form label-position="top">
            <FormItem label="密码">
                <Input v-model="password" type="password" placeholder="请输入密码"></Input>
            </FormItem>
            <FormItem>
                <Button @click="submit" type="primary">提交</Button>
            </FormItem>
        </Form>
    </div>
</template>

<script>
import http from '@/http';

export default {
    name: 'Login',
    data () {
        return {
            password: ''
        };
    },
    methods: {
        async submit () {
            if (!this.password) {
                this.$Modal.error({
                    title: '错误',
                    content: '请输入密码'
                });
                return;
            }
            await http.post('login', {}, {password: this.password});
            this.$Message.success('登录成功');
            this.$router.replace({name: 'Index'});
        }
    }
};
</script>

<style scoped>
.main {
    max-width: 500px;
    margin-top: 100px;
    margin-left: auto;
    margin-right: auto;
}
</style>
