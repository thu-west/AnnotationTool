<template>
    <div>
        <Divider>添加数据集</Divider>
        <DatasetForm :dataset="dataset" :for_create="true" @submit="handleCreate"/>
    </div>
</template>

<script>
import DatasetForm from '@/components/DatasetForm';
import http from '@/http';

export default {
    name: 'DatasetAdd',
    components: {
        DatasetForm
    },
    data () {
        return {
            dataset: {}
        };
    },
    methods: {
        async handleCreate () {
            await http.post('create_dataset', {}, this.dataset);
            this.$Message.success('创建数据集成功');
            this.$router.push({name: 'Index'});
        }
    }
};
</script>
