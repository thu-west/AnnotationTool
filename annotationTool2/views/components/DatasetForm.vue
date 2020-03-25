<template>
    <div>
        <Form :model="dataset" ref="datasetform" :rules="rules" :label-width="120">
            <FormItem label="数据集标题" prop="title">
                <Input v-model="dataset.title" placeholder="请输入数据集标题" />
            </FormItem>
            <FormItem label="数据集描述" prop="description">
                <Input
                    v-model="dataset.description"
                    type="textarea"
                    :autosize="{minRows: 3}"
                    placeholder="请输入数据集描述"
                />
            </FormItem>
            <FormItem>
                <Button
                    type="primary"
                    @click="handleSubmit('datasetform')"
                >{{ for_create ? '创建' : '修改' }}</Button>
                <Button type="error" @click="handleDelete()" v-if="for_edit">删除</Button>
            </FormItem>
        </Form>
    </div>
</template>

<script>
// emit: submit, delete
export default {
    props: {
        dataset: Object,
        for_create: Boolean,
        for_edit: Boolean
    },
    data () {
        return {
            rules: {
                title: [
                    {
                        required: true,
                        message: '数据库标题是必填',
                        trigger: 'blur'
                    }
                ]
            }
        };
    },
    methods: {
        handleSubmit (name) {
            this.$refs[name].validate(valid => {
                if (valid) {
                    this.$emit('submit');
                }
            });
        },
        handleDelete () {
            this.$emit('delete');
        }
    }
};
</script>
