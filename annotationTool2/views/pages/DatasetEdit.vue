<template>
    <div>
        <Divider>修改数据集</Divider>
        <DatasetForm :dataset="dataset" :for_edit="true" @submit="handleSubmit" @delete="handleDelete" />
        <Divider>数据集的标注任务列表</Divider>
        <TaskList :tasks="dataset.tasks || []" :for_edit="true" @update="update"/>
        <Divider>添加数据集的标注任务</Divider>
        <Form ref="taskForm" :model="task" :rules="taskRules" :label-width="120">
            <FormItem label="标注任务名称" prop="title">
                <Input v-model="task.title" placeholder="请输入标注任务名称"/>
            </FormItem>
            <FormItem>
                <Button type="primary" @click="handleCreateTask('taskForm')">添加标注任务</Button>
            </FormItem>
        </Form>
    </div>
</template>

<script>
import DatasetForm from '@/components/DatasetForm';
import TaskList from '@/components/TaskList';
import http from '@/http';
import _ from 'lodash';

export default {
    name: 'DatasetEdit',
    components: {
        DatasetForm,
        TaskList
    },
    data () {
        return {
            dataset: {},
            task: {},
            taskRules: {
                title: {
                    required: true, message: '标注任务的标题必填', trigger: 'bur'
                }
            }
        };
    },
    async created () {
        this.update();
    },
    methods: {
        async update () {
            let { data } = await http.get('get_dataset', {dataset_id: this.$route.params.dataset_id});
            this.dataset = data;
        },
        async handleSubmit () {
            await http.post('update_dataset', {}, _.assign(_.clone(this.dataset), {dataset_id: this.$route.params.dataset_id}));
            this.$Message.success('修改成功');
            await this.update();
        },
        async handleDelete () {
            this.$Modal.confirm({
                title: '确认删除数据集',
                content: '如果删除，可以联系网站管理员进行找回，是否删除？',
                onOk: async () => {
                    await http.post('delete_dataset', {}, {dataset_id: this.$route.params.dataset_id});
                    this.$Message.success('删除成功');
                    this.$router.replace({name: 'Index'});
                }
            });
        },
        async handleCreateTask (name) {
            this.$refs[name].validate(async (valid) => {
                if (valid) {
                    await http.post('create_dataset_task', {}, {dataset_id: this.$route.params.dataset_id, title: this.task.title});
                    this.$Message.success('添加标注任务成功');
                    await this.update();
                }
            });
        }
    }
};
</script>
