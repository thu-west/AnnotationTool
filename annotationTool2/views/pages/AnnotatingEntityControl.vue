<template>
    <div>
        <Breadcrumb>
            <BreadcrumbItem :to="{name: 'Index'}">Home</BreadcrumbItem>
            <BreadcrumbItem :to="{name: 'DatasetChooseTask', params: {dataset_id: (task.dataset||{})._id}}">{{(task.dataset||{}).title}}</BreadcrumbItem>
            <BreadcrumbItem>{{task.title}}</BreadcrumbItem>
            <BreadcrumbItem>实体标签管理</BreadcrumbItem>
        </Breadcrumb>
        <br/>
        <div class="main">
            <Card :bordered="true">
                <h2 slot="title">实体标签管理</h2>
                <h3>鼠标右键点击分栏或者实体标签，就可以进行相应的修改。每次修改会自动保存到服务器上，请谨慎操作。</h3>
                <h3>修改之后，请刷新标注页面或点击标注页面的“刷新”按钮以同步修改内容。</h3>
                <Button class="btn" size="small" type="info" ghost @click="addsplit()"><Icon type="md-add" />添加分栏</Button>
                <Button class="btn" size="small" type="info" ghost @click="addtag()"><Icon type="md-add" />添加实体标签</Button>
                <div v-for="(s, s_idx) in tag_splits" :key="s_idx">
                    <Divider orientation="left" size="small">
                        <span @contextmenu.prevent="$refs.split_menu.open($event, {s_idx})">{{s.title}}</span>
                    </Divider>
                    <Button class="btn" v-for="(t, idx) in tags.slice(s.start, s.start+s.size)" :key="t._id" :style="{background: t.color}">
                        <span @contextmenu.prevent="$refs.tag_menu.open($event, {t_idx: s.start + idx})">{{t.name}}({{t.symbol}})</span>
                    </Button>
                </div>
            </Card>
            <br/>
            <Card :bordered="true">
                <h2 slot="title">自动修改</h2>
                <Table stripe border :columns="autofit_columns" :data="tag_autofit">
                    <template slot-scope="{ index }" slot="delete">
                        <Button type="error" size="small" @click="removeAutofit(index)">删除</Button>
                    </template>
                </Table>
            </Card>
        </div>

        <vue-context ref="split_menu">
            <template slot-scope="child" v-if="child.data">
                <li>
                    <a href="#" @click.prevent="editsplit(child.data.s_idx)" >修改分栏标题</a>
                </li>
                <li>
                    <a href="#" @click.prevent="delsplit(child.data.s_idx)" >删除分栏</a>
                </li>
                <li>
                    <a href="#" @click.prevent="addsplit()" >添加分栏</a>
                </li>
            </template>
        </vue-context>

        <vue-context ref="tag_menu">
            <template slot-scope="child" v-if="child.data">
                <li>
                    <a href="#" @click.prevent="uptag(child.data.t_idx)" >移动到上一个分栏</a>
                </li>
                <li>
                    <a href="#" @click.prevent="downtag(child.data.t_idx)" >移动到下一个分栏</a>
                </li>
                <li>
                    <a href="#" @click.prevent="moveforwardtag(child.data.t_idx)" >向前移动</a>
                </li>
                <li>
                    <a href="#" @click.prevent="movebackwardtag(child.data.t_idx)" >向后移动</a>
                </li>
                <li>
                    <a href="#" @click.prevent="edittag(child.data.t_idx)" >修改实体标签</a>
                </li>
                <li>
                    <a href="#" @click.prevent="deltag(child.data.t_idx)" >删除实体标签</a>
                </li>
                <li>
                    <a href="#" @click.prevent="addtag()" >添加实体标签</a>
                </li>
                <li>
                    <a href="#" @click.prevent="showautofit(child.data.t_idx)" >设置自动修改</a>
                </li>
            </template>
        </vue-context>

        <!-- -->
        <Modal
            v-model="show_tag_modal"
            :title="tag_modal_mode === 'add' ? '添加实体标签' : '修改实体标签'"
            :footer-hide="true">
            <Form ref="tagForm" :model="tag_form" :rules="tag_rules" :label-width="80">
                <FormItem prop="color" label="颜色">
                    <ColorPicker v-model="tag_form.color" alpha />
                </FormItem>
                <FormItem prop="name" label="实体名称">
                    <Input type="text" v-model="tag_form.name" placeholder="比如：时间"/>
                </FormItem>
                <FormItem prop="symbol" label="实体符号">
                    <Input type="text" v-model="tag_form.symbol" :disabled="tag_modal_mode === 'edit'" placeholder="比如：MI"/>
                </FormItem>
                <FormItem>
                    <Button type="primary" @click="handleTagSubmit('tagForm')">{{ tag_modal_mode === 'add' ? '添加' : '修改' }}</Button>
                </FormItem>
            </Form>
        </Modal>

        <!-- -->
        <Modal
            v-model="show_autofit_modal"
            title="设置自动修改"
            :footer-hide="true">
            <Form ref="autofitForm" :model="autofit_form" :label-width="80">
                <FormItem label="前缀">
                    <Input type="text" v-model="autofit_form.prefix" placeholder="比如：无"/>
                </FormItem>
                <FormItem label="后缀">
                    <Input type="text" v-model="autofit_form.suffix" placeholder="比如：缓解"/>
                </FormItem>
                <p>示例："感冒" => "{{autofit_form.prefix}}感冒{{autofit_form.suffix}}"</p>
                <FormItem>
                    <Button type="primary" @click="handleAutofitSubmit('autofitForm')">设置</Button>
                </FormItem>
            </Form>
        </Modal>
    </div>
</template>

<script>
import http from '@/http';
import _ from 'lodash';
import color from 'color';
import { VueContext } from 'vue-context';
import 'vue-context/dist/css/vue-context.css';

export default {
    name: 'AnnotatingEntityControl',
    components: {
        VueContext
    },
    data () {
        return {
            task: {},
            tags: [],
            tag_splits: [],
            tag_autofit: [],

            autofit_columns: [
                {
                    title: '实体',
                    render: (h, params) => {
                        return h('span', _.find(this.tags, t => t.symbol === params.row.symbol).name);
                    }
                },
                {
                    title: '前缀',
                    key: 'prefix'
                },
                {
                    title: '后缀',
                    key: 'suffix'
                },
                {
                    title: '示例',
                    render: (h, params) => {
                        return h('p', `"感冒" => "${params.row.prefix}感冒${params.row.suffix}"`);
                    }
                },
                {
                    title: '删除',
                    slot: 'delete'
                }
            ],
            show_autofit_modal: false,
            autofit_form: {
                symbol: '',
                prefix: '',
                suffix: ''
            },

            split_title: '',
            show_tag_modal: false,
            tag_modal_mode: 'add', // add | edit
            tag_form: {
                color: '#fff',
                name: '',
                symbol: ''
            },
            tag_rules: {
                color: {
                    required: true,
                    trigger: 'change'
                },
                name: {
                    required: true,
                    message: '实体名称必填',
                    trigger: 'blur'
                },
                symbol: {
                    required: true,
                    message: '实体符号必填',
                    trigger: 'blur'
                }
            }
        };
    },
    async created () {
        await this.updateTask();
    },
    methods: {
        async updateTask () {
            let { data } = await http.get('get_dataset_task', {task_id: this.$route.params.task_id});
            this.task = data;
            this.tags = data.tags;
            this.tag_splits = data.tag_splits;
            this.tag_autofit = data.tag_autofit;
        },
        filterAutofit () {
            this.tag_autofit = this.tag_autofit.filter(fit => _.some(this.tags, t => t.symbol === fit.symbol));
        },
        async updateServer () {
            await http.post('set_dataset_task_tags', {}, {task_id: this.$route.params.task_id, tags: this.tags, tag_splits: this.tag_splits, tag_autofit: this.tag_autofit});
        },
        editsplit (s_idx) {
            this.split_title = this.tag_splits[s_idx].title;
            this.$Modal.confirm({
                title: '修改分栏标题',
                render: (h) => {
                    return h('Input', {
                        props: {
                            value: this.split_title
                        },
                        on: {
                            input: (val) => {
                                this.split_title = val;
                            }
                        }
                    });
                },
                onOk: async () => {
                    this.tag_splits[s_idx].title = this.split_title;
                    await this.updateServer();
                    this.$Message.success('修改成功');
                }
            });
        },
        async delsplit (s_idx) {
            if (s_idx === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '无法删除第一个分栏'
                });
                return;
            }
            this.$Modal.confirm({
                title: '确认删除',
                content: `确认删除分栏'${this.tag_splits[s_idx].title}'?`,
                onOk: async () => {
                    this.tag_splits[s_idx - 1].size += this.tag_splits[s_idx].size;
                    this.tag_splits.splice(s_idx, 1);
                    await this.updateServer();
                    this.$Message.success('删除成功');
                }
            });
        },
        async addsplit () {
            this.split_title = '新分栏标题';
            this.$Modal.confirm({
                title: '添加分栏',
                render: (h) => {
                    return h('Input', {
                        props: {
                            value: this.split_title
                        },
                        on: {
                            input: (val) => {
                                this.split_title = val;
                            }
                        }
                    });
                },
                onOk: async () => {
                    this.tag_splits.push({
                        title: this.split_title,
                        start: this.tags.length,
                        size: 0
                    });
                    await this.updateServer();
                    this.$Message.success('添加成功');
                }
            });
        },

        async downtag (t_idx) {
            let tags = this.tags.slice();
            let tag_splits = this.tag_splits.slice();

            let s_idx = -1;
            for (let i = 0; i < tag_splits.length; i++) {
                if (tag_splits[i].start <= t_idx && t_idx < tag_splits[i].start + tag_splits[i].size) {
                    s_idx = i;
                }
            }
            if (s_idx < 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '出现未知错误'
                });
                return;
            }
            if (s_idx === tag_splits.length - 1) {
                this.$Modal.error({
                    title: '错误',
                    content: '当前已经位于最后一个分栏，无法向下移动'
                });
                return;
            }

            let item = tags[t_idx];
            tags.splice(t_idx, 1);
            tag_splits[s_idx].size--;
            for (let i = s_idx + 1; i < tag_splits.length; i++) {
                tag_splits[i].start--;
            }
            tags.splice(tag_splits[s_idx + 1].start, 0, item);
            tag_splits[s_idx + 1].size++;
            for (let i = s_idx + 2; i < tag_splits.length; i++) {
                tag_splits[i].start++;
            }

            this.tags = tags;
            this.tag_splits = tag_splits;
            await this.updateServer();
            this.$Message.success('移动成功');
        },
        async uptag (t_idx) {
            let tags = this.tags.slice();
            let tag_splits = this.tag_splits.slice();

            let s_idx = -1;
            for (let i = 0; i < tag_splits.length; i++) {
                if (tag_splits[i].start <= t_idx && t_idx < tag_splits[i].start + tag_splits[i].size) {
                    s_idx = i;
                }
            }
            if (s_idx < 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '出现未知错误'
                });
                return;
            }
            if (s_idx === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '当前已经位于第一个分栏，无法向上移动'
                });
                return;
            }

            let item = tags[t_idx];
            tags.splice(t_idx, 1);
            tag_splits[s_idx].size--;
            for (let i = s_idx + 1; i < tag_splits.length; i++) {
                tag_splits[i].start--;
            }
            tags.splice(tag_splits[s_idx - 1].start + tag_splits[s_idx - 1].size, 0, item);
            tag_splits[s_idx - 1].size++;
            for (let i = s_idx; i < tag_splits.length; i++) {
                tag_splits[i].start++;
            }

            this.tags = tags;
            this.tag_splits = tag_splits;
            await this.updateServer();
            this.$Message.success('移动成功');
        },
        async moveforwardtag (t_idx) {
            let tags = this.tags.slice();
            let tag_splits = this.tag_splits.slice();

            let s_idx = -1;
            for (let i = 0; i < tag_splits.length; i++) {
                if (tag_splits[i].start <= t_idx && t_idx < tag_splits[i].start + tag_splits[i].size) {
                    s_idx = i;
                }
            }
            if (s_idx < 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '出现未知错误'
                });
                return;
            }
            if (tag_splits[s_idx].start === t_idx) {
                this.$Modal.error({
                    title: '错误',
                    content: '已经位于当前分栏的第一个，无法向前移动'
                });
                return;
            }

            let item0 = tags[t_idx];
            let item1 = tags[t_idx - 1];
            tags.splice(t_idx - 1, 2, item0, item1);

            this.tags = tags;
            await this.updateServer();
            this.$Message.success('移动成功');
        },
        async movebackwardtag (t_idx) {
            let tags = this.tags.slice();
            let tag_splits = this.tag_splits.slice();

            let s_idx = -1;
            for (let i = 0; i < tag_splits.length; i++) {
                if (tag_splits[i].start <= t_idx && t_idx < tag_splits[i].start + tag_splits[i].size) {
                    s_idx = i;
                }
            }
            if (s_idx < 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '出现未知错误'
                });
                return;
            }
            if (tag_splits[s_idx].start + tag_splits[s_idx].size - 1 === t_idx) {
                this.$Modal.error({
                    title: '错误',
                    content: '已经位于当前分栏的最后一个，无法向后移动'
                });
                return;
            }

            let item0 = tags[t_idx];
            let item1 = tags[t_idx + 1];
            tags.splice(t_idx, 2, item1, item0);

            this.tags = tags;
            await this.updateServer();
            this.$Message.success('移动成功');
        },
        edittag (t_idx) {
            this.tag_form.color = this.tags[t_idx].color;
            this.tag_form.name = this.tags[t_idx].name;
            this.tag_form.symbol = this.tags[t_idx].symbol;
            this.show_tag_modal = true;
            this.tag_modal_mode = 'edit';
        },
        async deltag (t_idx) {
            let tags = this.tags.slice();
            let tag_splits = this.tag_splits.slice();

            let s_idx = -1;
            for (let i = 0; i < tag_splits.length; i++) {
                if (tag_splits[i].start <= t_idx && t_idx < tag_splits[i].start + tag_splits[i].size) {
                    s_idx = i;
                }
            }
            if (s_idx < 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '出现未知错误'
                });
                return;
            }

            this.$Modal.confirm({
                title: '确认删除',
                content: `确认删除实体标签'${tags[t_idx].name}(${tags[t_idx].symbol})'?`,
                onOk: async () => {
                    tags.splice(t_idx, 1);
                    tag_splits[s_idx].size--;
                    for (let i = s_idx + 1; i < tag_splits.length; i++) {
                        tag_splits[i].start--;
                    }
                    this.tags = tags;
                    this.tag_splits = tag_splits;
                    this.filterAutofit();
                    await this.updateServer();
                    this.$Message.success('移动成功');
                }
            });
        },
        addtag (t_idx) {
            this.tag_form.color = color.hsv(Math.floor(Math.random() * 360), 100, 100).string();
            this.tag_form.name = '';
            this.tag_form.symbol = '';
            this.show_tag_modal = true;
            this.tag_modal_mode = 'add';
        },
        handleTagSubmit (name) {
            this.$refs[name].validate(async (valid) => {
                if (valid) {
                    let ot_idx = -1;
                    for (let i = 0; i < this.tags.length; i++) {
                        if (this.tags[i].symbol === this.tag_form.symbol) {
                            ot_idx = i;
                        }
                    }

                    if (this.tag_modal_mode === 'add') {
                        if (ot_idx >= 0) {
                            this.$Message.error(`与'${this.tags[ot_idx].name}'实体标签具有相同的符号`);
                            return;
                        }
                        this.tags.push({color: this.tag_form.color, name: this.tag_form.name, symbol: this.tag_form.symbol});
                        this.tag_splits[this.tag_splits.length - 1].size++;
                    } else {
                        if (ot_idx < 0) {
                            this.$Message.error(`未知错误`);
                            return;
                        }
                        this.$set(this.tags, ot_idx, {color: this.tag_form.color, name: this.tag_form.name, symbol: this.tag_form.symbol});
                    }
                    this.filterAutofit();
                    await this.updateServer();
                    this.show_tag_modal = false;
                    this.$Message.success('修改成功');
                }
            });
        },

        showautofit (t_idx) {
            this.autofit_form.symbol = this.tags[t_idx].symbol;
            this.autofit_form.prefix = '';
            this.autofit_form.suffix = '';
            this.show_autofit_modal = true;
        },
        async handleAutofitSubmit (name) {
            this.tag_autofit = this.tag_autofit.filter(fit => fit.symbol !== this.autofit_form.symbol);
            this.tag_autofit.push(_.clone(this.autofit_form));
            await this.updateServer();
            this.show_autofit_modal = false;
            this.$Message.success('设置成功');
        },
        async removeAutofit (index) {
            this.tag_autofit.splice(index, 1);
            await this.updateServer();
            this.$Message.success('删除成功');
        }
    }
};
</script>

<style scoped>
.main {
    max-width: 900px;
    padding-left: 50px;
    padding-right: 50px;
    margin-left: auto;
    margin-right: auto;
}
.btn {
    margin: 5px;
}
</style>
