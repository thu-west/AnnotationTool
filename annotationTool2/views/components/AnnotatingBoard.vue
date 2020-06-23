<template>
    <div>
        <Split v-model="split" class="split-box">
            <div slot="left" class="split-item">
                <Card dis-hover :shadow="false" :padding="6">
                    <h4>实体标注说明：先用鼠标选择(划取)下面的实体文字，然后点击上面对应的实体名称。双击已经标注的文本可以取消标注。鼠标右键已经标注的实体可以对实体文本进行修改。</h4>
                    <Row>
                        <span class="btn" v-if="task.tags && task.tags.length == 0">暂无实体标签</span>

                        <div v-for="(s, s_idx) in task.tag_splits" :key="s_idx">
                            <Divider orientation="left" size="small">{{s.title}}</Divider>
                            <Button class="btn" v-for="t in task.tags.slice(s.start, s.start+s.size)" :key="t._id" @click="setTag(t)" :style="{background: t.color}">
                                {{t.name}}
                            </Button>
                        </div>

                        <Divider size="small"><Icon type="ios-settings" />操作</Divider>
                        <router-link :to="{name: 'AnnotatingEntityControl', params: $route.params}" target="_blank">
                            <Button class="btn" size="small" type="info" ghost><Icon type="ios-analytics-outline" />控制面板</Button>
                        </router-link>
                        <Button @click="update" class="btn" size="small" type="info" ghost><Icon type="ios-refresh" />刷新</Button>
                    </Row>
                </Card>
                <br/>
                <Card dis-hover :shadow="false" :padding="6">
                    <p>关系标注说明：请先选择需要标注的关系类型，然后选择需要标注的关系标签，然后依次点选“实体1”和“实体2”，然后选择(划取)支持文本。</p>
                    <p>注：关系标注中，实体1和实体2为必填项，支持文本为可选项，可在选择完毕实体1和实体2之后，直接点击“添加实体关系”来添加无支持文本的关系。</p>
                    <p>注：关系自动生成请在完成实体标注之后进行。</p>
                    <Row>
                        <table class="table">
                            <tr>
                                <th style="min-width: 7em">关系类型:</th>
                                <td>
                                    <RadioGroup v-model="relation_type_with_text">
                                        <Radio label="one2one|一对一" :disabled="relationship_running !== null">
                                            <span>一对一</span>
                                        </Radio>
                                        <Radio label="one2many|一对多_和" :disabled="relationship_running !== null">
                                            <span>一对多_和</span>
                                        </Radio>
                                        <Radio label="one2many|一对多_或" :disabled="relationship_running !== null">
                                            <span>一对多_或</span>
                                        </Radio>
                                        <Radio label="one2many|一对多_一" :disabled="relationship_running !== null">
                                            <span>一对多_一</span>
                                        </Radio>
                                        <Radio label="many2one|多对一_和" :disabled="relationship_running !== null">
                                            <span>多对一_和</span>
                                        </Radio>
                                        <Radio label="many2one|多对一_或" :disabled="relationship_running !== null">
                                            <span>多对一_或</span>
                                        </Radio>
                                        <Radio label="many2one|多对一_一" :disabled="relationship_running !== null">
                                            <span>多对一_一</span>
                                        </Radio>
                                        <Radio label="many2many|多对多_和_和" :disabled="relationship_running !== null">
                                            <span>多对多_和_和</span>
                                        </Radio>
                                    </RadioGroup>
                                </td>
                            </tr>
                            <tr>
                                <th style="min-width: 6em">关系标签:</th>
                                <td>
                                    <span class="btn" v-if="task.relation_tags && task.relation_tags.length == 0">暂无关系标签</span>
                                    <Button class="btn" v-for="r in task.relation_tags" :key="r" @click="setRelation(r)" :disabled="relation_type_with_text.length === 0 || relationship_running !== null">{{r}}</Button>
                                </td>
                            </tr>
                            <tr>
                                <th style="min-width: 6em">操作:</th>
                                <td>
                                    <router-link :to="{name: 'AnnotatingRelationControl', params: $route.params}" target="_blank">
                                        <Button class="btn" size="small" type="info" ghost><Icon type="ios-analytics-outline" />控制面板</Button>
                                    </router-link>
                                    <Button @click="update" class="btn" size="small" type="info" ghost><Icon type="ios-refresh" />刷新</Button>
                                    <Button @click="autogenRelation" class="btn" size="small" type="info" ghost><Icon type="ios-aperture-outline" />关系自动生成</Button>
                                </td>
                            </tr>
                            <tr>
                                <th style="min-width: 6em">字体大小:</th>
                                <td>
                                    <Slider v-model="font_size" :step="1" :min="5" :max="25"></Slider>
                                </td>
                            </tr>
                        </table>
                    </Row>
                    <Row v-if="relationship_running"> <!-- 标注窗口 -->
                        <br/>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="min-width: 5em">关系类型</th>
                                    <th style="min-width: 9em">实体1</th>
                                    <th style="min-width: 7em">关系</th>
                                    <th style="min-width: 9em">实体2</th>
                                    <th>支持文本</th>
                                    <th style="min-width: 6em">#</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr style="text-align: center">
                                    <td></td>
                                    <td>
                                        <a href="#" @click.prevent="editEntity1">添加实体1</a>
                                    </td>
                                    <td></td>
                                    <td>
                                        <a href="#" @click.prevent="editEntity2">添加实体2</a>
                                    </td>
                                    <td>
                                        <a href="#" @click.prevent="editSupportText">修改</a>
                                        |
                                        <a href="#" @click.prevent="clearSupportText">清空</a>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr :style="fontSizeStyle">
                                    <td>
                                        {{ relationship_running.relation_type_text }}
                                    </td>
                                    <td>
                                        <ul>
                                            <li v-for="(entity, idx) in relationship_running.entity1" :key="idx">
                                                <Button @click="removeRunningEntity('entity1', idx)" type="error" size="small" shape="circle" icon="md-close" ghost></Button>
                                                {{ entity.text }}
                                            </li>
                                            <li class="rplaceholder" v-if="!relationship_running.entity1 || relationship_running.entity1.length === 0 || relationship_running.running === 'entity1'" :class="{rrunning: relationship_running.running === 'entity1' }" >实体1</li>
                                            <li v-if="relationship_running.entity1 && relationship_running.entity1.length > 0 && relationship_running.running === 'entity1' && running_entity1_multi"><a href="#" @click.prevent="endEntity1">选择完毕</a></li>
                                        </ul>
                                    </td>
                                    <td>
                                        {{ relationship_running.relation }}
                                    </td>
                                    <td>
                                        <ul>
                                            <li v-for="(entity, idx) in relationship_running.entity2" :key="idx">
                                                <Button @click="removeRunningEntity('entity2', idx)" type="error" size="small" shape="circle" icon="md-close" ghost></Button>
                                                {{ entity.text }}
                                            </li>
                                            <li class="rplaceholder" v-if="!relationship_running.entity2 || relationship_running.entity2.length === 0 || relationship_running.running === 'entity2'" :class="{rrunning: relationship_running.running === 'entity2' }" >实体2</li>
                                            <li v-if="relationship_running.entity2 && relationship_running.entity2.length > 0 && relationship_running.running === 'entity2' && running_entity2_multi"><a href="#" @click.prevent="endEntity2">选择完毕</a></li>
                                        </ul>
                                    </td>
                                    <td>
                                        <span :class="{rrunning: relationship_running.running === 'support_text', rplaceholder: !relationship_running.support_text}">
                                            {{ relationship_running.support_text ? relationship_running.support_text : '关系支持文本' }}
                                        </span>
                                    </td>
                                    <td>
                                        <ul>
                                            <li>
                                                <a href="#" @click.prevent="addRelation()">
                                                    添加实体关系
                                                </a>
                                            </li>
                                            <li>
                                                <a href="#" @click.prevent="relationship_running = null">取消当前标注</a>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                        <br/>
                    </Row>
                    <Row> <!-- 展示窗口 -->
                        <br/>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="min-width: 5em">关系类型</th>
                                    <th style="min-width: 9em">实体1</th>
                                    <th style="min-width: 7em">关系</th>
                                    <th style="min-width: 9em">实体2</th>
                                    <th>支持文本</th>
                                    <th style="min-width: 6em">#</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="relationships.length == 0" :style="fontSizeStyle">
                                    <td colspan="6">暂无关系</td>
                                </tr>
                                <tr v-for="(r, idx) in relationships.slice().reverse()" :key="idx" :style="fontSizeStyle">
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
                                    <td>
                                        <Button class="btn" size="small" type="info" ghost @click="modifyRelationship(relationships.length - idx - 1)"><Icon type="md-close" />修改</Button>
                                        <Button class="btn" size="small" type="info" ghost @click="removeRelationship(relationships.length - idx - 1)"><Icon type="md-close" />删除</Button>
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                        <br/>
                    </Row>
                    <Row v-if="relationship_running"> <!-- 提示文本 -->
                        当前正在进行的操作：
                        <span v-if="relationship_running.running === 'entity1'">
                            请点选实体1
                        </span>
                        <span v-else-if="relationship_running.running === 'entity2'">
                            请点选实体2
                        </span>
                        <span v-else-if="relationship_running.running === 'support_text'">
                            请勾选支持此关系的文本。也可添加无支持文本的实体关系
                        </span>
                        <span v-else>
                            未知操作
                        </span>
                    </Row>
                </Card>
                <div style="height: 700px"></div>
            </div>
            <div slot="right" class="split-item">
                <Row class="board">
                    <pre class="break"><span ref="items" v-for="(t, idx) in otags" :data="idx" :key="t.start+'~'+t.end" v-on:click.right="showTextModify(idx)" v-on:click="click(idx)" v-on:mouseup="mouseup()" v-on:dblclick="dbclick(idx)" :style="{background: findColor(t.symbol)}">{{text.slice(t.start, t.end)}}</span></pre>
                </Row>
                <Row style="margin-top: 5px">
                    <Button @click="show_confirm_modal = true">查看标注结果</Button>
                </Row>
            </div>
        </Split>

        <!-- -->
        <Modal
            v-model="show_modify_modal"
            title="修改文本"
            :footer-hide="true">
            <Form ref="modifyForm" :model="modify_form" :rules="modify_rules" :label-width="80">
                <FormItem prop="text" label="文本">
                    <Input type="text" v-model="modify_form.text"/>
                </FormItem>
                <FormItem>
                    <Button type="primary" @click="handleTextModifySubmit('modifyForm')">修改</Button>
                </FormItem>
            </Form>
        </Modal>

        <!-- -->
        <Modal
            v-model="show_confirm_modal"
            title="确认标注"
            @on-ok="handleSubmit"
            ok-text="提交标注"
            cancel-text="取消"
            :width="60">
            <div style="text-align: right;">
                <Button type="text" @click="show_confirm_modal = false">取消</Button>
                <Button type="primary" @click="handleSubmit">提交标注</Button>
            </div>
            <Divider size="small">实体标注：</Divider>
            <Row v-for="t in task.tags" :key="t._id">
                <Button class="btn" :style="{background: t.color}">{{t.name}}({{t.symbol}})</Button>
                <span v-if="otags.filter(ot => ot.symbol == t.symbol).length == 0">
                    : 无
                </span>
                <span v-else>
                    :
                    <span v-for="(ot, idx) in otags.filter(ot => ot.symbol == t.symbol)" :key="ot.start">
                        {{ idx == 0 ? ot.text : ' | ' + ot.text }}
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
                    <tr v-if="relationships.length == 0">
                        <td colspan="5">
                            无关系标注
                        </td>
                    </tr>
                    <tr v-for="(r, idx) in relationships.slice().reverse()" :key="idx">
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
        </Modal>
    </div>
</template>

<script>
import _ from 'lodash';

// update()
// submit({otags, orelationships}) // [{length, symbol, text}]
export default {
    name: 'AnnotatingBoard',
    props: {
        task: Object,
        text: String, // 文本
        intags: Array, // [{length, symbol, text}]
        inrelationships: Array // []
    },
    data () {
        return {
            split: 0.5,

            otags: [], // {start, end, symbol, text}

            font_size: 16,

            relation_type_with_text: '',
            relationships: [],
            relationship_modifing_idx: -1,
            relationship_running: null, // {running: string, entity1, relation, entity2, support_text, relation_type, relation_type_text}
            last_relationship_running: Date.now(), // ms

            // 修改文本
            show_modify_modal: false,
            modify_idx: -1,
            modify_form: {
                text: ''
            },
            modify_rules: {
                text: {
                    required: true,
                    message: '文本必填',
                    trigger: 'blur'
                }
            },

            show_confirm_modal: false
        };
    },
    created () {
        this.clearAll();
        this.init();
    },
    watch: {
        task () {
            this.init();
        },
        text () {
            this.clearAll();
            this.init();
        },
        intags () {
            this.init();
        },
        inrelationships () {
            this.relationships = this.inrelationships.slice();
        }
    },
    computed: {
        fontSizeStyle () {
            return {
                fontSize: this.font_size + 'px'
            };
        },
        running_entity1_multi () { // 正在标注的实体1是否是多个
            if (!this.relation_type_with_text) return false;
            let type = this.relation_type_with_text.split('|')[0];
            let types = type.split('2');
            if (types.length !== 2) return false;
            return types[0] === 'many';
        },
        running_entity2_multi () {
            if (!this.relation_type_with_text) return false;
            let type = this.relation_type_with_text.split('|')[0];
            let types = type.split('2');
            if (types.length !== 2) return false;
            return types[1] === 'many';
        }
    },
    methods: {
        update () {
            this.$emit('update');
        },
        findColor (symbol) {
            let tag = _.find(this.task.tags, t => t.symbol === symbol);
            if (tag) return tag.color;
            return '#fff';
        },
        showTextModify (idx) {
            if (this.otags[idx].symbol === 'O') {
                this.$Modal.warning({
                    title: '错误',
                    content: '只能对实体文本进行修改'
                });
                return;
            }

            this.show_modify_modal = true;
            this.modify_idx = idx;
            this.modify_form.text = this.otags[idx].text;
        },
        handleTextModifySubmit (name) {
            this.$refs[name].validate((valid) => {
                if (valid) {
                    this.otags[this.modify_idx].text = this.modify_form.text;
                    this.otags = this.mergeTags(this.otags);
                    this.show_modify_modal = false;
                    this.$Message.success('修改成功');
                }
            });
        },
        // 将相邻的符号相同的段进行合并
        mergeTags (otags) {
            otags = _.cloneDeep(otags);
            otags = otags.filter(t => t.start < t.end); // 去掉长度为0的
            for (let i = 0; i < otags.length; i++) {
                if (otags[i].symbol === 'O') { //
                    otags[i].text = this.text.slice(otags[i].start, otags[i].end);
                }
                if (i > 0 && otags[i].start !== otags[i - 1].end) {
                    this.$Message.error({
                        title: '错误',
                        content: '出现错误[0],请联系管理员'
                    });
                    throw new Error('出现错误[0],请联系管理员');
                }
            }

            let merged_otags = [];
            for (let i = 0; i < otags.length; i++) {
                if (merged_otags.length === 0) {
                    merged_otags.push(_.clone(otags[i]));
                } else {
                    if (merged_otags[merged_otags.length - 1].symbol === otags[i].symbol) {
                        if (merged_otags[merged_otags.length - 1].end !== otags[i].start) {
                            this.$Message.error('出现错误：合并出错，请联系管理员进行处理。');
                            throw new Error('出现错误：合并出错，请联系管理员进行处理。');
                        }
                        merged_otags[merged_otags.length - 1].end = otags[i].end;
                        merged_otags[merged_otags.length - 1].text += otags[i].text;
                    } else {
                        merged_otags.push(_.clone(otags[i]));
                    }
                }
            }
            return merged_otags;
        },
        clearAll () {
            this.otags = [];

            this.relationships = [];
            this.relationship_running = null;
        },
        init () {
            // =================== otags =========================
            let otags = [];
            let error_flag = false;

            if (!this.task.tags || !this.text) {
                otags = [];
            } else {
                if (this.otags && this.otags.length > 0) {
                    otags = this.otags;
                } else if (!this.intags) {
                    otags = [{
                        start: 0,
                        end: this.text.length,
                        symbol: 'O',
                        text: this.text
                    }];
                } else {
                    let sum_length = 0;
                    for (let i = 0; i < this.intags.length; i++) {
                        sum_length += this.intags[i].length;
                    }
                    if (sum_length !== this.text.length) {
                        this.$Message.error(`出现错误：tags长度总和不相同(${this.text.length} vs ${sum_length})，请联系管理员进行处理。`);
                        error_flag = true;
                    }
                    if (!error_flag) {
                        let start = 0;
                        for (let i = 0; i < this.intags.length; i++) {
                            otags.push({
                                start,
                                end: start + this.intags[i].length,
                                symbol: this.intags[i].symbol,
                                text: this.intags[i].text
                            });
                            start += this.intags[i].length;
                        }
                    }
                }
            }

            // 整理
            for (let i = 0; i < otags.length; i++) {
                if (!_.some(this.task.tags, t => t.symbol === otags[i].symbol)) {
                    otags[i].symbol = 'O';
                }
            }
            let merged_otags = [];
            try {
                merged_otags = this.mergeTags(otags);
            } catch (e) {
                error_flag = true;
            }

            // check
            for (let i = 0; i < merged_otags.length; i++) {
                if (i > 0 && merged_otags[i].start !== merged_otags[i - 1].end) {
                    error_flag = true;
                    this.$Message.error('出现错误：检查1，请联系管理员进行处理。');
                }
                if (i === 0 && merged_otags[i].start !== 0) {
                    error_flag = true;
                    this.$Message.error('出现错误：检查2，请联系管理员进行处理。');
                }
                if (i === merged_otags.length - 1 && merged_otags[i].end !== this.text.length) {
                    error_flag = true;
                    this.$Message.error('出现错误：检查3，请联系管理员进行处理。');
                }
            }

            if (error_flag) {
                this.otags = [
                    {
                        start: 0,
                        end: this.text.length,
                        symbol: 'O',
                        text: this.text
                    }
                ];
            } else {
                this.otags = merged_otags;
            }
            // =================== otags =========================
        },
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
            idx = Number(this.$refs['items'][idx].getAttribute('data'));
            console.log(rangeObj);
            console.log('idx', idx);

            if (this.otags[idx].symbol !== 'O') {
                this.$Modal.error({
                    title: '错误',
                    content: '该文本已经被标注了其他实体。'
                });
                return;
            }

            let prefix = '';
            let suffix = '';
            let autofit = _.find(this.task.tag_autofit, fit => fit.symbol === tag.symbol);
            if (autofit) {
                prefix = autofit.prefix;
                suffix = autofit.suffix;
            }

            let otags = _.clone(this.otags);
            otags = _.concat(
                otags.slice(0, idx),
                {
                    start: otags[idx].start,
                    end: rangeObj.startOffset + otags[idx].start,
                    symbol: otags[idx].symbol,
                    text: this.text.slice(otags[idx].start, rangeObj.startOffset + otags[idx].start)
                },
                {
                    start: rangeObj.startOffset + otags[idx].start,
                    end: rangeObj.endOffset + otags[idx].start,
                    symbol: tag.symbol,
                    text: prefix + this.text.slice(rangeObj.startOffset + otags[idx].start, rangeObj.endOffset + otags[idx].start) + suffix
                },
                {
                    start: rangeObj.endOffset + otags[idx].start,
                    end: otags[idx].end,
                    symbol: otags[idx].symbol,
                    text: this.text.slice(rangeObj.endOffset + otags[idx].start, otags[idx].end)
                },
                otags.slice(idx + 1)
            );

            this.otags = this.mergeTags(otags);
        },
        click (idx) {
            if (!this.relationship_running) return;
            this.last_relationship_running = Date.now();
            if (this.relationship_running.running === 'entity1' || this.relationship_running.running === 'entity2') {
                let otags = _.clone(this.otags);
                let tag = otags[idx];
                if (tag.symbol === 'O') {
                    this.$Message.error('请选择一个实体');
                } else {
                    if (!this.relationship_running[this.relationship_running.running]) {
                        this.relationship_running[this.relationship_running.running] = [];
                    }
                    this.relationship_running[this.relationship_running.running].push({
                        start_pos: tag.start,
                        end_pos: tag.end,
                        text: tag.text
                    });
                    this.relationship_running = _.clone(this.relationship_running); // Vue响应
                    if (this.relationship_running.running === 'entity1') {
                        if (!this.running_entity1_multi) {
                            this.relationship_running.running = 'entity2';
                        }
                    } else {
                        if (!this.running_entity2_multi) {
                            this.relationship_running.running = 'support_text';
                        }
                    }
                }
            }
        },
        endEntity1 () {
            if (!this.relationship_running) return;
            this.last_relationship_running = Date.now();
            if (this.relationship_running.running !== 'entity1') return;
            if (this.relationship_running.entity1.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '请至少选择一个实体'
                });
                return;
            }
            this.relationship_running.running = 'entity2';
        },
        endEntity2 () {
            if (!this.relationship_running) return;
            this.last_relationship_running = Date.now();
            if (this.relationship_running.running !== 'entity2') return;
            if (this.relationship_running.entity2.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '请至少选择一个实体'
                });
                return;
            }
            this.relationship_running.running = 'support_text';
        },
        editEntity1 () {
            this.relationship_running.entity1 = this.relationship_running.entity1 || [];
            this.relationship_running.entity2 = this.relationship_running.entity2 || [];
            if (!this.running_entity1_multi && this.relationship_running.entity1.length >= 1) {
                this.$Modal.error({
                    title: '错误',
                    content: `关系类型"${this.relationship_running.relation_type_text}"只能有一个实体1`
                });
                return;
            }
            this.relationship_running.running = 'entity1';
            this.relationship_running = _.clone(this.relationship_running); // Vue响应
        },
        editEntity2 () {
            this.relationship_running.entity1 = this.relationship_running.entity1 || [];
            this.relationship_running.entity2 = this.relationship_running.entity2 || [];
            if (!this.relationship_running.entity1 || this.relationship_running.entity1.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: `请先选择实体1`
                });
                return;
            }
            if (!this.running_entity2_multi && this.relationship_running.entity2.length >= 1) {
                this.$Modal.error({
                    title: '错误',
                    content: `关系类型"${this.relationship_running.relation_type_text}"只能有一个实体2`
                });
                return;
            }
            this.relationship_running.running = 'entity2';
            this.relationship_running = _.clone(this.relationship_running); // Vue响应
        },
        editSupportText () {
            this.relationship_running.entity1 = this.relationship_running.entity1 || [];
            this.relationship_running.entity2 = this.relationship_running.entity2 || [];
            if (!this.relationship_running.entity1 || this.relationship_running.entity1.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: `请先选择实体1`
                });
                return;
            }
            if (!this.relationship_running.entity2 || this.relationship_running.entity2.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: `请先选择实体2`
                });
                return;
            }
            this.relationship_running.running = 'support_text';
            this.relationship_running = _.clone(this.relationship_running); // Vue响应
        },
        clearSupportText () {
            this.relationship_running.entity1 = this.relationship_running.entity1 || [];
            this.relationship_running.entity2 = this.relationship_running.entity2 || [];
            if (!this.relationship_running.entity1 || this.relationship_running.entity1.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: `请先选择实体1`
                });
                return;
            }
            if (!this.relationship_running.entity2 || this.relationship_running.entity2.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: `请先选择实体2`
                });
                return;
            }
            this.relationship_running.running = 'support_text';
            this.relationship_running.support_text = '';
            this.relationship_running = _.clone(this.relationship_running); // Vue响应
        },
        mouseup () {
            if (!this.relationship_running || this.relationship_running.running !== 'support_text') return;
            this.last_relationship_running = Date.now();

            if (!window.getSelection) {
                alert('请使用谷歌浏览器火狐浏览器进行操作。');
                return;
            }
            let selectionObj = window.getSelection();
            if (selectionObj.type !== 'Range') {
                alert('请先选择支持关系的文本。');
                return;
            }
            let rangeObj = selectionObj.getRangeAt(0);
            let start_idx = -1;
            let end_idx = -1;
            for (let i = 0; i < this.$refs['items'].length; i++) {
                if (this.$refs['items'][i] === rangeObj.startContainer.parentNode) {
                    start_idx = i;
                }
                if (this.$refs['items'][i] === rangeObj.endContainer.parentNode) {
                    end_idx = i;
                }
            }
            if (start_idx < 0 || end_idx < 0) {
                alert('选择的文本非法。');
                return;
            }
            start_idx = Number(this.$refs['items'][start_idx].getAttribute('data'));
            end_idx = Number(this.$refs['items'][end_idx].getAttribute('data'));

            let otags = _.clone(this.otags);
            let text = this.text.slice(otags[start_idx].start + rangeObj.startOffset, otags[end_idx].start + rangeObj.endOffset);
            // for (let i = start_idx; i <= end_idx; i++) {
            //     let this_start = otags[i].start;
            //     let this_end = otags[i].end;
            //     if (i === start_idx) {
            //         this_start = rangeObj.startOffset + otags[i].start;
            //     }
            //     if (i === end_idx) {
            //         this_end = rangeObj.endOffset + otags[i].start;
            //     }
            //     text = text + this.text.slice(this_start, this_end);
            // }
            this.relationship_running.support_text = text;
            this.relationship_running = _.clone(this.relationship_running); // Vue响应
            // this.relationships = _.concat(this.relationships, [this.relationship_running]);
            // this.relationship_running = null;
            // this.$Message.success('添加关系成功');
        },
        addRelation () { // 添加关系
            if (!this.relationship_running) return;
            if (this.relationship_running.entity1.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '请至少选择一个实体1'
                });
                return;
            }
            if (this.relationship_running.entity2.length === 0) {
                this.$Modal.error({
                    title: '错误',
                    content: '请至少选择一个实体2'
                });
                return;
            }
            if (!this.running_entity1_multi && this.relationship_running.entity1.length > 1) {
                this.$Modal.error({
                    title: '错误',
                    content: `关系类型"${this.relationship_running.relation_type_text}"只能有一个实体1`
                });
                return;
            }
            if (!this.running_entity2_multi && this.relationship_running.entity2.length > 1) {
                this.$Modal.error({
                    title: '错误',
                    content: `关系类型"${this.relationship_running.relation_type_text}"只能有一个实体2`
                });
                return;
            }

            if (this.relationship_modifing_idx >= 0) {
                this.$set(this.relationships, this.relationship_modifing_idx, this.relationship_running);
            } else {
                this.relationships = _.concat(this.relationships, [this.relationship_running]);
            }
            this.relationship_running = null;
            this.$Message.success('添加关系成功');
        },
        removeRunningEntity (attr, idx) {
            this.relationship_running[attr].splice(idx, 1);
            this.relationship_running.running = attr;
            this.relationship_running = _.clone(this.relationship_running); // Vue响应
        },
        removeRelationship (idx) {
            if (this.relationship_running) {
                this.$Modal.error({
                    title: '错误',
                    content: '当前正在进行关系标注，无法删除关系。'
                });
                return;
            }
            this.relationships.splice(idx, 1);
        },
        modifyRelationship (idx) {
            if (this.relationship_running) {
                this.$Modal.error({
                    title: '错误',
                    content: '当前正在进行关系标注，无法修改关系。'
                });
                return;
            }
            this.relation_type_with_text = this.relationships[idx].relation_type + '|' + this.relationships[idx].relation_type_text;
            this.last_relationship_running = Date.now();
            this.relationship_modifing_idx = idx;
            this.relationship_running = _.cloneDeep(this.relationships[idx]);
            this.relationship_running.running = 'support_text';
        },
        dbclick (idx) {
            if (this.relationship_running || Date.now() - this.last_relationship_running < 1000) {
                this.$Modal.error({
                    title: '错误',
                    content: '你双击了一个实体文本，但是目前正在进行关系标注，无法删除实体文本。如果要删除实体文本请结束关系标注之后再进行。'
                });
                return;
            }
            let otags = _.clone(this.otags);
            otags[idx].symbol = 'O';
            this.otags = this.mergeTags(otags);
        },
        setRelation (re) { // 开始标注关系
            this.last_relationship_running = Date.now();
            this.relationship_modifing_idx = -1;
            this.relationship_running = {
                running: 'entity1',
                relation_type: this.relation_type_with_text.split('|')[0],
                relation_type_text: this.relation_type_with_text.split('|')[1],
                relation: re
            };
        },
        autogenRelation () {
            let ignored = 0;
            let success = 0;
            let emit = (r) => {
                for (let i = 0; i < 2; i++) {
                    if (r[`entity${i + 1}`].length === 0) {
                        ignored += 1;
                        return;
                    }
                    if (r.relation_type.split('2')[i] === 'one' && r[`entity${i + 1}`].length > 1) {
                        ignored += 1;
                        return;
                    }
                }
                success += 1;
                this.relationships.push(r);
            };

            let search = (gen, attr, pos, r) => {
                r[attr.slice(0, attr.length - 1)] = r[attr.slice(0, attr.length - 1)] || []; // entity1s -> entity1
                if (attr === 'entity2s' && pos >= gen[attr].length) {
                    r.relation_type = gen.relation_type;
                    r.relation_type_text = gen.relation_type_text;
                    r.relation = gen.relation;
                    emit(r);
                    return;
                }
                if (attr === 'entity1s' && pos >= gen[attr].length) {
                    search(gen, 'entity2s', 0, r);
                    return;
                }

                // otags: [], // {start, end, symbol, text}
                let entities = _.cloneDeep(this.otags).filter(t => t.symbol === gen[attr][pos].symbol);
                if (entities.length === 0) {
                    search(gen, attr, pos + 1, r);
                    return;
                }

                if (gen[attr][pos].type === 'one') {
                    for (let e of entities) {
                        let rr = _.cloneDeep(r);
                        rr[attr.slice(0, attr.length - 1)] = _.concat(rr[attr.slice(0, attr.length - 1)], [e]);
                        search(gen, attr, pos + 1, rr);
                    }
                } else { // all
                    let rr = _.cloneDeep(r);
                    rr[attr.slice(0, attr.length - 1)] = _.concat(rr[attr.slice(0, attr.length - 1)], entities);
                    search(gen, attr, pos + 1, rr);
                }
            };

            for (let gen of this.task.relation_autogen) {
                search(gen, 'entity1s', 0, {});
            }
            this.$Modal.info({
                title: '关系自动生成',
                content: `成功生成${success}条关系，另有${ignored}条生成的关系不符合规范被忽略了。`
            });
        },
        handleSubmit () {
            let otags = this.otags.map(i => {
                return {
                    length: i.end - i.start,
                    symbol: i.symbol,
                    text: i.text
                };
            });
            this.$emit('submit', {otags, orelationships: _.clone(this.relationships)});
            this.show_confirm_modal = false;
        }
    }
};
</script>

<style scoped>
.board {
    border: 1px solid #c7c7c7;
    border-radius: 2px;
    padding: 5px;
}
.break {
    white-space: pre-wrap;
    word-wrap: break-word;
}
.btn {
    margin: 5px;
}
.rplaceholder {
    text-align: center;
    color: #9c9c9c;
}
.rrunning {
    border: 1px solid red;
    border-radius: 2px;
}
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
.marginh {
    margin-right: 10px;
}
.split-box {
    height: 650px;
}
.split-item {
    padding-left: 20px;
    padding-right: 10px;
    height: 650px;
    overflow-y: scroll;
    overflow-x: scroll;
}
</style>
