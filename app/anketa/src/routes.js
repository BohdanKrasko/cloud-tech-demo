'use strict'

const path     = require('path')
const handlers = require(path.join(__dirname, 'handlers.js')).handlers

let routes = [
    {
        method: 'GET',
        path: '/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/signin/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/signup/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/ankety/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/anketa/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/anketa/add/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/anketa/edit/:anketa_id/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/statistics/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/children/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/profile/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: 'GET',
        path: '/dashboard/admin/{path*}',
        handler: {
            directory: { 
                path: '.',
                listing: false,
                index: true
            }
        }
    },
    {
        method: "GET",
        path: '/api/v1/test',
        config: handlers.v1.get.test
    },
    {
        method: "GET",
        path: '/api/v1/get/ankety',
        config: handlers.v1.get.ankety
    },
    {
        method: "GET",
        path: '/api/v1/get/anketa/{anketa_id}',
        config: handlers.v1.get.anketa
    },
    {
        method: "GET",
        path: '/api/v1/get/children/{parents_id}',
        config: handlers.v1.get.children
    },
    {
        method: "GET",
        path: '/api/v1/get/anketa/{anketa_id}/children/{children_id}',
        config: handlers.v1.get.statistic
    },
    {
        method: "GET",
        path: '/api/v1/get/all/children/anketa/{anketa_id}',
        config: handlers.v1.get.all.childrenByAnketaId
    },
    {
        method: "GET",
        path: '/api/v1/get/all/children/anketa/{anketa_id}/parent/{parents_id}',
        config: handlers.v1.get.all.childrenByAnketaAndParent
    },
    {
        method: "GET",
        path: '/api/v1/get/user/{username}',
        config: handlers.v1.get.userByUsername
    },
    {
        method: "GET",
        path: '/api/v1/get/all/admins',
        config: handlers.v1.get.all.admins
    },
    {
        method: "POST",
        path: '/api/v1/exist/answers',
        config: handlers.v1.exist.answers
    },
    {
        method: "GET",
        path: '/api/v1/exist/user/{parents_id}/username/{username}',
        config: handlers.v1.exist.user
    },
    {
        method: "POST",
        path: '/api/v1/create/admin',
        config: handlers.v1.create.admin
    },
    {
        method: "POST",
        path: '/api/v1/create/children',
        config: handlers.v1.create.children
    },
    {
        method: "POST",
        path: '/api/v1/create/anketa',
        config: handlers.v1.create.anketa
    },
    {
        method: "POST",
        path: '/api/v1/create/child_answer',
        config: handlers.v1.create.child_answer
    },
    {
        method: "POST",
        path: '/api/v1/register',
        config: handlers.v1.register
    },
    {
        method: "POST",
        path: '/api/v1/login',
        config: handlers.v1.login
    },
    {
        method: "PUT",
        path: '/api/v1/edit/admin',
        config: handlers.v1.edit.admin
    },
    {
        method: "PUT",
        path: '/api/v1/edit/children',
        config: handlers.v1.edit.children
    },
    {
        method: "PUT",
        path: '/api/v1/edit/anketa',
        config: handlers.v1.edit.anketa
    },
    {
        method: "PUT",
        path: '/api/v1/edit/user',
        config: handlers.v1.edit.user
    },
    {
        method: "PUT",
        path: '/api/v1/edit/password',
        config: handlers.v1.edit.password
    },
    {
        method: "DELETE",
        path: '/api/v1/delete/children/{children_id}',
        config: handlers.v1.delete.children
    },
    {
        method: "DELETE",
        path: '/api/v1/delete/anketa/{anketa_id}',
        config: handlers.v1.delete.anketa
    },
    {
        method: "DELETE",
        path: '/api/v1/delete/admin/{admin_id}',
        config: handlers.v1.delete.admin
    }
]

exports.routes = routes