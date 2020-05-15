<template>
    <div>
        <Layout style="min-height: 100vh">
            <Header>
                <h2 style="color: #c7eaa8; text-align: center">医疗NER标注工具</h2>
            </Header>
            <Layout>
                <Sider collapsible :collapsed-width="78" v-model="isCollapsed" :style="{background: '#fff'}">
                    <Menu @on-select="handleSelect" theme="light" width="auto" :class="menuitemClasses">
                        <MenuItem name="index" :to="{name: 'Index'}"><Icon type="ios-home" />
                            <span>主页</span>
                        </MenuItem>
                        <Submenu name="dataset">
                            <template slot="title">
                                <Icon type="ios-analytics" />
                                <span>数据集</span>
                            </template>
                            <MenuItem name="dataset-create" :to="{name: 'DatasetAdd'}">
                                <span>添加数据集</span>
                            </MenuItem>
                        </Submenu>
                        <MenuItem name="logout"><Icon type="ios-exit" />
                            <span>登出</span>
                        </MenuItem>
                    </Menu>
                </Sider>
                <Layout :style="{padding: '24px 24px 24px'}">
                    <Content
                        :style="{padding: '24px 24px', minHeight: '280px', background: '#fff'}"
                    >
                        <router-view />
                    </Content>
                </Layout>
            </Layout>
        </Layout>
    </div>
</template>

<script>
import http from '@/http';

export default {
    name: 'MainLayout',
    data () {
        return {
            isCollapsed: false
        };
    },
    computed: {
        menuitemClasses: function () {
            return [
                'menu-item',
                this.isCollapsed ? 'collapsed-menu' : ''
            ];
        }
    },
    async created () {
        let status = await http.get('login_status');
        if (!status.is_logined) {
            this.$router.push({name: 'Login'});
        }
    },
    methods: {
        async handleSelect (name) {
            if (name === 'logout') {
                await http.post('logout');
                this.$Message.success('登出成功');
                this.$router.push({name: 'Login'});
            }
        }
    }
};
</script>

<style>
.menu-item span {
    display: inline-block;
    overflow: hidden;
    width: 69px;
    text-overflow: ellipsis;
    white-space: nowrap;
    vertical-align: bottom;
    transition: width .2s ease .2s;
}
.menu-item i {
    transform: translateX(0px);
    transition: font-size .2s ease, transform .2s ease;
    vertical-align: middle;
    font-size: 16px;
}
.collapsed-menu span {
    width: 0px;
    transition: width .2s ease;
}
.collapsed-menu i {
    transform: translateX(2px);
    transition: font-size .2s ease .2s, transform .2s ease .2s;
    vertical-align: middle;
    font-size: 16px;
}
.collapsed-menu i.ivu-menu-submenu-title-icon {
    display: none;
}
</style>
