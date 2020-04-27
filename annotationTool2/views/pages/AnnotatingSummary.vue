<template>
    <div>
        <Breadcrumb>
            <BreadcrumbItem :to="{name: 'Index'}">Home</BreadcrumbItem>
            <BreadcrumbItem :to="{name: 'DatasetChooseTask', params: {dataset_id: (task.dataset||{})._id}}">{{(task.dataset||{}).title}}</BreadcrumbItem>
            <BreadcrumbItem :to="{name: 'Annotating', params: {task_id: $route.params.task_id}}">{{task.title}}</BreadcrumbItem>
            <BreadcrumbItem>概览</BreadcrumbItem>
        </Breadcrumb>
        <br/>
        <Divider size="small">实体标注：</Divider>
        <Row v-for="t in tags" :key="t._id">
            <Button class="btn" :style="{background: t.color}">{{t.name}}({{t.symbol}})</Button>
            <span v-if="entity_tags[t.symbol].length == 0">
                : 无
            </span>
            <span v-else>
                :
                <span v-for="(t, idx) in entity_tags[t.symbol]" :key="idx">
                    {{ idx == 0 ? t : ' | ' + t }}
                </span>
            </span>
        </Row>
        <Divider size="small">关系标注：</Divider>
        <table class="table table-center">
            <thead>
                <tr>
                    <th>关系类型</th>
                    <th>实体1</th>
                    <th>关系</th>
                    <th>实体2</th>
                    <th>支持文本</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="relation_tags.length == 0">
                    <td colspan="5">
                        无关系标注
                    </td>
                </tr>
                <tr v-for="(r, idx) in relation_tags.slice().reverse()" :key="idx">
                    <td>
                        {{ r.relation_type_text }}
                    </td>
                    <td>
                        <ul>
                            <li v-for="(entity, idx) in r.entity1" :key="idx">{{ entity.text }}</li>
                        </ul>
                    </td>
                    <td>
                        {{ r.relation }}
                    </td>
                    <td>
                        <ul>
                            <li v-for="(entity, idx) in r.entity2" :key="idx">{{ entity.text }}</li>
                        </ul>
                    </td>
                    <td>
                        {{ r.support_text }}
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
import http from '@/http';

export default {
    name: 'AnnotatingSummary',
    data () {
        return {
            task: {},
            tags: [],
            entity_tags: {},
            relation_tags: []
        };
    },
    async created () {
        await this.updateTask();
        await this.updateTaskSummary();
    },
    methods: {
        async updateTask () {
            let { data } = await http.get('get_dataset_task', {task_id: this.$route.params.task_id});
            this.task = data;
        },
        async updateTaskSummary () {
            this.$Spin.show();
            try {
                let data = await http.get('get_task_summary', {task_id: this.$route.params.task_id});
                this.entity_tags = data.entity_tags;
                this.relation_tags = data.relation_tags;
                this.tags = data.tags;
                setTimeout(() => {
                    this.$Spin.hide();
                }, 1000);
            } catch (e) {
                console.error(e);
                this.$Spin.hide();
            }
        }
    }
};
</script>
<style scoped>
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
</style>
