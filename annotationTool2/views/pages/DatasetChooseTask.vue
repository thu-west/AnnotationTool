<template>
    <div>
        <Divider>请选择标注任务</Divider>
        <p>可以在<router-link :to="{name: 'DatasetEdit', params: {dataset_id: $route.params.dataset_id}}">修改数据</router-link>页面添加或删除标注任务。</p>
        <TaskList :tasks="dataset.tasks || []" @update="update" />
    </div>
</template>

<script>
import TaskList from '@/components/TaskList';
import http from '@/http';

export default {
    name: 'DatasetChooseTask',
    components: {
        TaskList
    },
    data () {
        return {
            dataset: {}
        };
    },
    async created () {
        await this.update();
    },
    methods: {
        async update () {
            let { data } = await http.get('get_dataset', {dataset_id: this.$route.params.dataset_id});
            this.dataset = data;
        }
    }
};
</script>
