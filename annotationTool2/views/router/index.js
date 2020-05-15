import Vue from 'vue';
import Router from 'vue-router';

import MainLayout from '@/pages/MainLayout';
import ReLayout from '@/pages/ReLayout';

import Login from '@/pages/Login';

import Index from '@/pages/Index';
import DatasetAdd from '@/pages/DatasetAdd';
import DatasetEdit from '@/pages/DatasetEdit';
import DatasetInsert from '@/pages/DatasetInsert';
import DatasetChooseTask from '@/pages/DatasetChooseTask';

import Annotating from '@/pages/Annotating';
import AnnotatingEntityControl from '@/pages/AnnotatingEntityControl';
import AnnotatingRelationControl from '@/pages/AnnotatingRelationControl';
import AnnotatingSummary from '@/pages/AnnotatingSummary';

import Test from '@/pages/Test';

Vue.use(Router);

export default new Router({
    mode: 'history',
    routes: [
        {
            path: '/',
            component: MainLayout,
            children: [
                {
                    path: '',
                    component: ReLayout,
                    children: [
                        {
                            path: '',
                            name: 'Index',
                            component: Index
                        },
                        {
                            path: 'dataset_add',
                            name: 'DatasetAdd',
                            component: DatasetAdd
                        },
                        {
                            path: 'dataset_edit/:dataset_id',
                            name: 'DatasetEdit',
                            component: DatasetEdit
                        },
                        {
                            path: 'dataset_insert/:dataset_id',
                            name: 'DatasetInsert',
                            component: DatasetInsert
                        },
                        {
                            path: 'dataset_choose_task/:dataset_id',
                            name: 'DatasetChooseTask',
                            component: DatasetChooseTask
                        }
                    ]
                },
                {
                    path: 'annotating/:task_id',
                    name: 'Annotating',
                    component: Annotating
                },
                {
                    path: 'annotating/:task_id/entity_control',
                    name: 'AnnotatingEntityControl',
                    component: AnnotatingEntityControl
                },
                {
                    path: 'annotating/:task_id/relation_control',
                    name: 'AnnotatingRelationControl',
                    component: AnnotatingRelationControl
                },
                {
                    path: 'annotating/:task_id/summary',
                    name: 'AnnotatingSummary',
                    component: AnnotatingSummary
                }
            ]
        },
        {
            path: '/login',
            name: 'Login',
            component: Login
        },
        {
            path: '/test',
            name: 'Test',
            component: Test
        }
    ]
});
