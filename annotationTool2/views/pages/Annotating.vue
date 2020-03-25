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
        <AnnotatingBoard :tags="task.tags" :text="task_item.content" :intags="show_machine ? task_item.tags : null" @addtag="addtag" @deltag="deltag" @submit="submit"/>
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
            let { data } = await http.get('get_next_task_item', {task_id: this.$route.params.task_id});
            this.task_item = data;
        },
        async addtag (tag) {
            await http.post('add_dataset_task_tag', {}, _.assign(_.clone(tag), {task_id: this.$route.params.task_id}));
            this.$Message.success('添加成功');
            await this.updateTask();
        },
        async deltag (symbol) {
            await http.post('delete_dataset_task_tag', {}, _.assign({symbol}, {task_id: this.$route.params.task_id}));
            this.$Message.success('删除成功');
            await this.updateTask();
        },
        async submit (otags) {
            await http.post('set_task_item_tags', {}, {
                task_id: this.$route.params.task_id,
                dataset_item_id: this.task_item.dataset_item,
                tags: otags
            });
            this.$Message.success('提交标注成功');
            await this.updateTaskItem();
        }
    }
};
</script>
