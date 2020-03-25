<template>
    <div>
        <Divider>添加数据</Divider>
        <div class="upload">
            <Upload :action="upload_url" name="datafile" :data="{dataset_id: $route.params.dataset_id}" :on-success="onSuccess">
                <Button size="large" icon="ios-cloud-upload-outline">上传数据</Button>
            </Upload>
        </div>
        <br/>
        <Card :bordered="true" dis-hover>
            <p slot="title">上传说明</p>
            <p>上传的文件为JSON格式的文本文件，内容是一个数组，数组中的每个元素是一个对象，包含id和content两个属性，均为字符串类型。</p>
            <p>id表示数据的编号，id不能为空且两边不能有空白，用于在导出数据时会带上此编号，content是需要标注的内容。</p>
            <p>示例：</p>
            <pre v-html="JSON.stringify(example, null, 4)"></pre>
        </Card>
    </div>
</template>

<script>
import http from '@/http';

export default {
    name: 'DatasetInsert',
    data () {
        return {
            upload_url: http.baseURL + 'insert_dataset',
            example: [
                {
                    id: '0001',
                    content: '这是需要标注的内容1'
                },
                {
                    id: '0002',
                    content: '这是需要标注的内容2'
                },
                {
                    id: '0003',
                    content: '这是需要标注的内容3'
                }
            ]
        };
    },
    methods: {
        onSuccess (res) {
            if (!res.success) {
                this.$Modal.error({
                    title: '出现错误',
                    content: res.message
                });
                return;
            }
            let fileid = res.data.fileid;
            let insertable = res.data.insertable;
            let message = res.data.message;
            if (!insertable) {
                this.$Modal.error({
                    title: '无法添加数据',
                    content: `你的数据存在以下问题：${message}`
                });
            } else {
                this.$Modal.confirm({
                    title: '确认添加数据？',
                    content: message ? `你的数据存在以下问题：${message}，但是可以被添加，是否添加？` : '你的数据可以被添加，确认添加？',
                    loading: true,
                    onOk: async () => {
                        await http.post('insert_dataset_confirm', {}, {fileid, dataset_id: this.$route.params.dataset_id});
                        this.$Modal.remove();
                        this.$Message.success('添加数据成功');
                        this.$router.push({name: 'Index'});
                    }
                });
            }
        }
    }
};
</script>

<style scoped>
.upload {
    text-align: center;
}
</style>
