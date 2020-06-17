<template>
    <div>
        <List :border="true">
            <ListItem v-if="tasks.length == 0">
                <h4>暂无标注任务</h4>
            </ListItem>
            <ListItem v-for="task in tasks" :key="task._id">
                <h4>{{ task.title }}</h4>
                <Tag type="border">已标注{{ task.passed_num }}条数据</Tag>
                <template slot="action">
                    <li>
                        <router-link :to="{name: 'Annotating', params: {task_id: task._id}}">开始标注</router-link>
                    </li>
                    <li>
                        <p v-if="task.machine_running">正在主动学习</p>
                        <a v-else href="#" @click.prevent="handleMachine(task)">主动学习</a>
                    </li>
                    <li>
                        <Poptip trigger="hover" title="主动学习状态" :content="task.machine_status">
                            <a href="#" @click.prevent="">主动学习状态</a>
                        </Poptip>
                    </li>
                    <li>
                        <Poptip trigger="hover" title="下载标注">
                            <div slot="content">
                                <a :href="'/api/download_task_entities?task_id=' + task._id">下载实体标注</a>
                                |
                                <a :href="'/api/download_task_triple?task_id=' + task._id">下载关系标注</a>
                                |
                                <a :href="'/api/download_task_triple_std?task_id=' + task._id">下载关系三元组</a>
                                |
                                <a :href="'/api/download_task_triple_std_v2?task_id=' + task._id">下载关系三元组v2</a>
                            </div>
                            <a href="#" @click.prevent="">下载标注</a>
                        </Poptip>
                    </li>
                    <li v-if="for_edit">
                        <a href="#" @click.prevent="handleDeleteTask(task)">删除</a>
                    </li>
                </template>
            </ListItem>
        </List>
    </div>
</template>

<script>
import http from '@/http';

// emit: update
export default {
    props: {
        tasks: Array,
        for_edit: Boolean
    },
    methods: {
        handleDeleteTask (task) {
            this.$Modal.confirm({
                title: '确认删除',
                content: '如果删除，可以联系网站管理员进行找回，是否删除？',
                onOk: async () => {
                    await http.post('delete_dataset_task', {}, {task_id: task._id});
                    this.$Message.success('删除成功');
                    this.$emit('update');
                }
            });
        },
        handleMachine (task) {
            this.$Modal.confirm({
                title: '启动主动学习？',
                content: '启动主动学习将会使用已经标注的数据进行学习，并对未标注的数据进行预测，并后续人工标注会优先标注机器信心较差的数据。',
                onOk: async () => {
                    await http.post('set_dataset_task_machine', {}, {task_id: task._id});
                    this.$Message.success('启动成功');
                    this.$emit('update');
                }
            });
        }
    }
};
</script>
