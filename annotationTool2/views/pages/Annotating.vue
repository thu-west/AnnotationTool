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
        <br/>
        <div>
            <AnnotatingBoard
                :tags="task.tags"
                :relation_tags="task.relation_tags"
                :text="task_item.content"
                :intags="show_machine ? task_item.tags : null"
                @addtag="addtag" @edittag="edittag" @deltag="deltag" @reordertag="reordertag" @setrelationtags="setrelationtags" @submit="submit"/>
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
            task_item: {}
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
        },
        async updateTaskItem () {
            this.$Spin.show();
            try {
                let { data } = await http.get('get_next_task_item', {task_id: this.$route.params.task_id});
                this.task_item = data;
                setTimeout(() => {
                    this.$Spin.hide();
                }, 1000);
            } catch (e) {
                this.$Spin.hide();
            }
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
                this.updateTaskItem();
            }, 1000); // 加一步确认
        }
    }
};
</script>
