<template>
    <div>
        <Layout style="min-height: 100vh">
            <Header>
                <h2 style="color: #c7eaa8; text-align: center">医疗NER标注工具</h2>
            </Header>
            <Layout>
                <Sider hide-trigger :style="{background: '#fff'}">
                    <Menu theme="light" width="auto">
                        <MenuItem name="index" :to="{name: 'Index'}"><Icon type="ios-home" />主页</MenuItem>
                        <Submenu name="dataset">
                            <template slot="title">
                                <Icon type="ios-analytics" />数据集
                            </template>
                            <MenuItem name="dataset-create" :to="{name: 'DatasetAdd'}">添加数据集</MenuItem>
                        </Submenu>
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
export default {
    name: 'MainLayout'
};
</script>
