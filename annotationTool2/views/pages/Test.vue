<template>
    <div>
        <p>
            <span ref="items" v-for="t in text" :key="t.content">{{t.content}}</span>
        </p>
        <button v-for="t in tags" :key="t" @click="setTag(t)">{{t}}</button>
    </div>
</template>

<script>
import _ from 'lodash';

export default {
    name: 'Test',
    data () {
        return {
            text: [{
                content: '这是一长短文字。',
                tag: 'O'
            }],
            tags: ['O', 'B']
        };
    },
    methods: {
        setTag (tag) {
            if (!window.getSelection) {
                alert('请使用谷歌浏览器火狐浏览器进行操作。');
                return;
            }
            let selectionObj = window.getSelection();
            if (selectionObj.type !== 'Range') {
                alert('请先选择文本。');
                return;
            }
            let rangeObj = selectionObj.getRangeAt(0);
            if (rangeObj.startContainer !== rangeObj.endContainer) {
                alert('选择的文本非法。');
                return;
            }
            let idx = -1;
            for (let i = 0; i < this.$refs['items'].length; i++) {
                if (this.$refs['items'][i] === rangeObj.startContainer.parentNode) {
                    idx = i;
                }
            }
            if (idx < 0) {
                alert('选择的文本非法。');
                return;
            }
            console.log(rangeObj);
            let contents = [];
            contents.push({
                content: this.text[idx].content.slice(0, rangeObj.startOffset),
                tag: this.text[idx].tag
            });
            contents.push({
                content: this.text[idx].content.slice(rangeObj.startOffset, rangeObj.endOffset),
                tag: tag
            });
            contents.push({
                content: this.text[idx].content.slice(rangeObj.endOffset),
                tag: this.text[idx].tag
            });
            let newText = _.concat(this.text.slice(0, idx), contents, this.text.slice(idx + 1));
            this.text = newText;
        }
    }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
