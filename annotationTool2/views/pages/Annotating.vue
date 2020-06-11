<template>
    <div>
        <Breadcrumb>
            <BreadcrumbItem :to="{name: 'Index'}">Home</BreadcrumbItem>
            <BreadcrumbItem :to="{name: 'DatasetChooseTask', params: {dataset_id: (task.dataset||{})._id}}">{{(task.dataset||{}).title}}</BreadcrumbItem>
            <BreadcrumbItem>{{task.title}}</BreadcrumbItem>
        </Breadcrumb>
        <br/>
        <Row>
            是否显示机器的标注结果（如果有）：
            <Switch v-model="show_machine" size="large" @on-change="configChange">
                <span slot="open">显示</span>
                <span slot="close">隐藏</span>
            </Switch>
        </Row>
        <Row>
            <Button type="info" :disabled="prev_pos === null" @click="prevItem">上一条</Button>
            <Button type="info" :disabled="next_pos === null" @click="nextItem">下一条</Button>
            (
                已标注{{task_item.num_pos}}个数据，
                正在标注第{{task_item.curr_pos}}个数据，
                快速跳转到：
                <Input v-model="switch_pos" style="width: 80px" icon="md-arrow-round-forward" @on-click="handleSwitch" @on-enter="handleSwitch"/>
            )
            <Button>
                <router-link :to="{name: 'AnnotatingSummary', params: {task_id: $route.params.task_id}}" target="_blank">打开当前标注任务概览</router-link>
            </Button>
        </Row>
        <br/>
        <Row>
            <h3>当前正在标注的数据ID：{{ task_item ? task_item.dataset_item_id : 'null' }}</h3>
        </Row>
        <br/>
        <div>
            <AnnotatingBoard
                :task="task"
                :text="task_item.content"
                :intags="show_machine ? task_item.tags : null"
                :inrelationships="task_item.relation_tags"
                @update="updateTask"
                @submit="submit"/>
        </div>
    </div>
</template>

<script>
import http from '@/http';
import _ from 'lodash';
import AnnotatingBoard from '@/components/AnnotatingBoard';

export default {
    name: 'Annotating',
    components: {
        AnnotatingBoard
    },
    data () {
        return {
            show_machine: true,
            task: {},
            task_item: {},
            pos: null,
            next_pos: null,
            prev_pos: null,
            switch_pos: 1
        };
    },
    async created () {
        try {
            if (localStorage.getItem('show_machine')) {
                this.show_machine = JSON.parse(localStorage.getItem('show_machine'));
            }
        } catch (e) {
            console.error(e);
        }
        await this.updateTask();
        await this.updateTaskItem();
    },
    methods: {
        configChange () {
            try {
                localStorage.setItem('show_machine', JSON.stringify(this.show_machine));
            } catch (e) {
                console.error(e);
            }
        },
        async updateTask () {
            let { data } = await http.get('get_dataset_task', {task_id: this.$route.params.task_id});
            this.task = data;
            this.$Message.success('刷新成功');
        },
        async nextItem () {
            this.pos = this.next_pos;
            await this.updateTaskItem();
        },
        async prevItem () {
            this.pos = this.prev_pos;
            await this.updateTaskItem();
        },
        async updateTaskItem () {
            this.$Spin.show();
            try {
                let { data } = await http.get('get_task_item', {task_id: this.$route.params.task_id, pos: this.pos});
                this.task_item = data;
                this.next_pos = data.next_pos;
                this.prev_pos = data.prev_pos;
                setTimeout(() => {
                    this.$Spin.hide();
                }, 1000);
            } catch (e) {
                console.error(e);
                this.$Spin.hide();
            }
        },
        async handleSwitch () {
            let pos = parseInt(this.switch_pos);
            if (pos < 1 || pos > this.task_item.num_pos) {
                this.$Modal.error({
                    title: '错误',
                    content: '跳转坐标超范围'
                });
                return;
            }
            this.pos = pos;
            await this.updateTaskItem();
        },
        async addtag (tag) {
            await http.post('add_dataset_task_tag', {}, _.assign(_.clone(tag), {task_id: this.$route.params.task_id}));
            this.$Message.success('添加成功');
            await this.updateTask();
        },
        async edittag (tag) {
            await http.post('modify_dataset_task_tag', {}, _.assign(_.clone(tag), {task_id: this.$route.params.task_id}));
            this.$Message.success('修改成功');
            await this.updateTask();
        },
        async deltag (symbol) {
            await http.post('delete_dataset_task_tag', {}, _.assign({symbol}, {task_id: this.$route.params.task_id}));
            this.$Message.success('删除成功');
            await this.updateTask();
        },
        async reordertag (symbols) {
            await http.post('reorder_dataset_task_tag', {}, _.assign({symbols}, {task_id: this.$route.params.task_id}));
        },
        async setrelationtags (names) {
            await http.post('set_dataset_task_relation_tag', {}, {task_id: this.$route.params.task_id, names});
            this.$Message.success('修改成功');
            await this.updateTask();
        },
        async submit ({otags, orelationships}) {
            await http.post('set_task_item_tags', {}, {
                task_id: this.$route.params.task_id,
                dataset_item_id: this.task_item.dataset_item,
                tags: otags,
                relation_tags: orelationships
            });
            this.$Message.success('提交标注成功');
            setTimeout(() => {
                this.pos = this.next_pos;
                this.updateTaskItem();
            }, 1000); // 加一步确认
        }
    }
};
</script>
