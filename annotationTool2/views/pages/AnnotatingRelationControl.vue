<template>
    <div>
        <Breadcrumb>
            <BreadcrumbItem :to="{name: 'Index'}">Home</BreadcrumbItem>
            <BreadcrumbItem :to="{name: 'DatasetChooseTask', params: {dataset_id: (task.dataset||{})._id}}">{{(task.dataset||{}).title}}</BreadcrumbItem>
            <BreadcrumbItem>{{task.title}}</BreadcrumbItem>
            <BreadcrumbItem>关系标签管理</BreadcrumbItem>
        </Breadcrumb>
        <br/>
        <div class="main">
            <Card :bordered="true">
                <h2 slot="title">关系标签管理</h2>
                <h3>鼠标右键点击关系标签，就可以进行相应的修改。每次修改会自动保存到服务器上，请谨慎操作。</h3>
                <h3>修改之后，请刷新标注页面或点击标注页面的“刷新”按钮以同步修改内容。</h3>
                <Button class="btn" size="small" type="info" ghost @click="addRelation()"><Icon type="md-add" />添加关系标签</Button>
                <Button class="btn" size="small" type="info" ghost @click="show_autogen_modal = true"><Icon type="md-add" />添加关系自动生成</Button>
                <div>
                    <Button class="btn" v-for="(r, r_idx) in relation_tags" :key="r">
                        <span @contextmenu.prevent="$refs.relation_menu.open($event, {r_idx})">{{r}}</span>
                    </Button>
                </div>
            </Card>
            <br/>
            <Card :bordered="true">
                <h2 slot="title">关系自动生成</h2>
                <Table stripe border :columns="autogen_columns" :data="relation_autogen">
                    <template slot-scope="{ row }" slot="entity1s">
                        <p v-for="(e, idx) in row.entity1s" :key="idx">{{e.type === 'all' ? '全' : '一'}} | {{ findEntity(e.symbol).name }}</p>
                    </template>
                    <template slot-scope="{ row }" slot="entity2s">
                        <p v-for="(e, idx) in row.entity2s" :key="idx">{{e.type === 'all' ? '全' : '一'}} | {{ findEntity(e.symbol).name }}</p>
                    </template>
                    <template slot-scope="{ index }" slot="delete">
                        <Button type="error" size="small" @click="removeAutogen(index)">删除</Button>
                    </template>
                </Table>
            </Card>
        </div>

        <vue-context ref="relation_menu">
            <template slot-scope="child" v-if="child.data">
                <li>
                    <a href="#" @click.prevent="editRelation(child.data.r_idx)" >修改关系名称</a>
                </li>
                <li>
                    <a href="#" @click.prevent="removeRelation(child.data.r_idx)" >删除关系</a>
                </li>
                <li>
                    <a href="#" @click.prevent="addRelation()" >添加关系</a>
                </li>
                <li>
                    <a href="#" @click.prevent="forwardRelation(child.data.r_idx)" >向前移动</a>
                </li>
                <li>
                    <a href="#" @click.prevent="backwardRelation(child.data.r_idx)" >向后移动</a>
                </li>
            </template>
        </vue-context>

        <!-- -->
        <Modal
            v-model="show_autogen_modal"
            title="添加关系自动生成"
            width="80"
            :footer-hide="true">
            <table class="table">
                <thead>
                    <tr>
                        <th>关系类型</th>
                        <th>关系</th>
                        <th>实体1</th>
                        <th>实体2</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <Select v-model="autogen.relation_type_with_text" class="select">
                                <Option v-for="item in possible_relation_types" :value="item" :key="item">{{ item.split('|')[1] }}</Option>
                            </Select>
                        </td>
                        <td>
                            <Select v-model="autogen.relation" class="select">
                                <Option v-for="item in relation_tags" :value="item" :key="item">{{ item }}</Option>
                            </Select>
                        </td>
                        <td>
                            <div class="line" v-for="(e, idx) in autogen.entity1s" :key="idx">
                                <Select v-model="e.symbol" style="width:200px">
                                    <Option v-for="item in task.tags" :value="item.symbol" :key="item._id">{{ item.name }}</Option>
                                </Select>
                                <Select v-model="e.type" style="width:100px">
                                    <Option value="all">全</Option>
                                    <Option value="one">一</Option>
                                </Select>
                                <Button @click="removeAutogenEntity('entity1s', idx)" class="btn" size="small" type="error" ghost shape="circle" icon="md-close"></Button>
                            </div>
                            <Button @click="addAutogenEntity('entity1s')" class="btn" size="small" type="success" ghost shape="circle" icon="md-add"></Button>
                        </td>
                        <td>
                            <div class="line" v-for="(e, idx) in autogen.entity2s" :key="idx">
                                <Select v-model="e.symbol" style="width:200px">
                                    <Option v-for="item in task.tags" :value="item.symbol" :key="item._id">{{ item.name }}</Option>
                                </Select>
                                <Select v-model="e.type" style="width:100px">
                                    <Option value="all">全</Option>
                                    <Option value="one">一</Option>
                                </Select>
                                <Button @click="removeAutogenEntity('entity2s', idx)" class="btn" size="small" type="error" ghost shape="circle" icon="md-close"></Button>
                            </div>
                            <Button @click="addAutogenEntity('entity2s')" class="btn" size="small" type="success" ghost shape="circle" icon="md-add"></Button>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p>关于实体选择中的“全”和“一”的说明：“全”表示自动生成的关系中会包含全部这个实体标签的全部实体文本，“一”表示自动生成的关系中只会包含一个实体文本。</p>
            <p>举例：假如一段标注文本中，属于“疾病”的实体有两个文本A和B，那么“全”的话会将A和B都包括在一条关系中，而“一”的话则会生成两条关系，各自包含A和B。</p>
            <div style="text-align: right">
                <Button type="primary" @click="addAutogen">添加</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
import http from '@/http';
import _ from 'lodash';
import { VueContext } from 'vue-context';
import 'vue-context/dist/css/vue-context.css';

export default {
    name: 'AnnotatingRelationControl',
    components: {
        VueContext
    },
    data () {
        return {
            task: {},
            relation_tags: [],
            relation_autogen: [], // [{entity1s: [], entity2s: [], relation_type, relation_type_text, relation}]

            autogen_columns: [
                {
                    title: '关系类型',
                    key: 'relation_type_text'
                },
                {
                    title: '实体1',
                    slot: 'entity1s'
                },
                {
                    title: '关系',
                    key: 'relation'
                },
                {
                    title: '实体2',
                    slot: 'entity2s'
                },
                {
                    title: '删除',
                    slot: 'delete'
                }
            ],

            relation_name: '',

            possible_relation_types: [
                'one2one|一对一',
                'one2many|一对多_和',
                'one2many|一对多_或',
                'one2many|一对多_一',
                'many2one|多对一_和',
                'many2one|多对一_或',
                'many2one|多对一_一',
                'many2many|多对多_和_和'
            ],
            show_autogen_modal: false,
            autogen: {
                relation_type_with_text: '',
                relation: '',
                entity1s: [],
                entity2s: []
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
            this.relation_tags = data.relation_tags;
            this.relation_autogen = data.relation_autogen;
        },
        filterAutogen () {
            this.relation_autogen = this.relation_autogen.filter(gen => _.includes(this.relation_tags, gen.relation));
        },
        async updateServer () {
            await http.post('set_dataset_task_relation_tags', {}, {task_id: this.$route.params.task_id, names: this.relation_tags, relation_autogen: this.relation_autogen});
        },

        addRelation () {
            this.relation_name = '关系名称';
            this.$Modal.confirm({
                title: '添加关系',
                render: (h) => {
                    return h('Input', {
                        props: {
                            value: this.relation_name
                        },
                        on: {
                            input: (val) => {
                                this.relation_name = val;
                            }
                        }
                    });
                },
                onOk: async () => {
                    if (!this.relation_name) {
                        this.$Modal.error({
                            title: '错误',
                            content: '关系名称不能为空'
                        });
                        return;
                    }
                    this.relation_tags.push(this.relation_name);
                    await this.updateServer();
                    this.$Message.success('添加成功');
                }
            });
        },
        editRelation (r_idx) {
            this.relation_name = this.relation_tags[r_idx];
            this.$Modal.confirm({
                title: '修改关系名称',
                render: (h) => {
                    return h('Input', {
                        props: {
                            value: this.relation_name
                        },
                        on: {
                            input: (val) => {
                                this.relation_name = val;
                            }
                        }
                    });
                },
                onOk: async () => {
                    if (!this.relation_name) {
                        this.$Modal.error({
                            title: '错误',
                            content: '关系名称不能为空'
                        });
                        return;
                    }
                    this.$set(this.relation_tags, r_idx, this.relation_name);
                    this.filterAutogen();
                    await this.updateServer();
                    this.$Message.success('添加成功');
                }
            });
        },
        removeRelation (r_idx) {
            this.$Modal.confirm({
                title: '确认删除',
                content: `确认删除关系'${this.relation_tags[r_idx]}'?`,
                onOk: async () => {
                    this.relation_tags.splice(r_idx, 1);
                    this.filterAutogen();
                    await this.updateServer();
                    this.$Message.success('删除成功');
                }
            });
        },
        async forwardRelation (r_idx) {
            if (r_idx === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '当前已经是第一个，无法向前移动。'
                });
                return;
            }

            let item0 = this.relation_tags[r_idx];
            let item1 = this.relation_tags[r_idx - 1];
            this.relation_tags.splice(r_idx - 1, 2, item0, item1);
            await this.updateServer();
            this.$Message.success('移动成功');
        },
        async backwardRelation (r_idx) {
            if (r_idx === this.relation_tags.length - 1) {
                this.$Modal.error({
                    title: '错误',
                    content: '当前已经是最后一个，无法向后移动。'
                });
                return;
            }

            let item0 = this.relation_tags[r_idx];
            let item1 = this.relation_tags[r_idx + 1];
            this.relation_tags.splice(r_idx, 2, item1, item0);
            await this.updateServer();
            this.$Message.success('移动成功');
        },

        showError (msg) {
            this.$Message.error({
                content: msg,
                duration: 3
            });
        },
        findEntity (symbol) {
            return _.find(this.task.tags, t => t.symbol === symbol);
        },
        addAutogenEntity (attr) {
            this.autogen[attr].push({
                symbol: '',
                type: 'all'
            });
        },
        removeAutogenEntity (attr, idx) {
            this.autogen[attr].splice(idx, 1);
        },
        async addAutogen () {
            let relation_type = this.autogen.relation_type_with_text.split('|')[0];
            let relation_type_text = this.autogen.relation_type_with_text.split('|')[1];
            if (!relation_type || !relation_type_text) {
                this.showError('请选择关系类型');
                return;
            }

            let relation = this.autogen.relation;
            if (!relation) {
                this.showError('请选择关系');
                return;
            }

            let entities = {};
            for (let attr of ['entity1s', 'entity2s']) {
                if (!this.autogen[attr] || this.autogen[attr].length === 0) {
                    this.showError('实体不能为空');
                    return;
                }
                for (let e of this.autogen[attr]) {
                    if (!e.symbol) {
                        this.showError('请选择实体');
                        return;
                    }
                    if (!_.some(this.task.tags, t => t.symbol === e.symbol)) {
                        this.showError('实体选择出错，请尝试全部删除后重新添加');
                        return;
                    }
                    if (!e.type || !_.includes(['all', 'one'], e.type)) {
                        this.showError('实体类型选择出错');
                        return;
                    }
                }
                entities[attr] = this.autogen[attr];
            }

            const entity_names = ['entity1s', 'entity2s'];
            for (let i = 0; i < entity_names.length; i++) {
                let num = relation_type.split('2')[i];
                if (num === 'one') {
                    if (entities[entity_names[i]].length > 1) {
                        this.showError(`"${relation_type_text}"关系类型不能选择多个实体${i + 1}`);
                        return;
                    }
                    if (entities[entity_names[i]][0].type === 'all') {
                        this.showError(`"${relation_type_text}"关系类型不能选择实体${i + 1}为"合"`);
                        return;
                    }
                }
            }

            this.relation_autogen.push(_.merge(entities, {relation_type, relation_type_text, relation}));
            this.filterAutogen();
            await this.updateServer();
            this.$Message.success('添加成功');
            this.show_autogen_modal = false;
        },
        async removeAutogen (index) {
            this.relation_autogen.splice(index, 1);
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
.table {
    width: 100%;
}
table.table, table.table th, table.table td {
    border: 1px solid black;
}
table.table {
    border-collapse: collapse;
}
table.table th, table.table td {
    padding-left: 10px;
    padding-right: 10px;
}
table.table ul, table.table ol {
    padding-left: 10px;
}
table.table-center th, table.table-center td {
    text-align: center;
}
.select {
    margin-top: 10px;
    margin-bottom: 10px;
}
.line {
    margin-top: 10px;
    margin-bottom: 10px;
    padding: 2px;
    border-width: 1px;
    border-style: solid;
    border-color: #b7b0b0;
}
</style>
