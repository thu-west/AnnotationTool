<template>
  <div>
    <div v-if="datasets.length == 0">
        <Card>
            <p slot="title">
                暂无数据集
            </p>
            <p>
                可以先<router-link :to="{name: 'DatasetAdd'}">创建数据集</router-link>。
            </p>
        </Card>
        <br/>
    </div>
    <div v-for="dataset in datasets" :key="dataset._id">
        <Card>
            <p slot="title">
                {{ dataset.title }}
            </p>
            <p>
                {{ dataset.description }}
            </p>
            <br/>
            <p>
                <Button type="dashed" @click="editDataset(dataset)">修改数据集</Button>
                <Button type="dashed" @click="insertData2Dataset(dataset)">添加数据</Button>
                <Button type="dashed" @click="startAnnotating(dataset)">开始标注</Button>
                <span>共{{ dataset.item_num }}条数据。</span>
            </p>
        </Card>
        <br/>
    </div>
  </div>
</template>

<script>
import http from '@/http';

export default {
    name: 'Index',
    data () {
        return {
            datasets: []
        };
    },
    async created () {
        let { data } = await http.get('list_dataset');
        this.datasets = data;
    },
    methods: {
        editDataset (dataset) {
            this.$router.push({name: 'DatasetEdit', params: {dataset_id: dataset._id}});
        },
        insertData2Dataset (dataset) {
            this.$router.push({name: 'DatasetInsert', params: {dataset_id: dataset._id}});
        },
        startAnnotating (dataset) {
            this.$router.push({name: 'DatasetChooseTask', params: {dataset_id: dataset._id}});
        }
    }
};
</script>
