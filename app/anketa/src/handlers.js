'use strict'

const path       = require("path")
const children   = require(path.join(__dirname, "./db/children"))
const anketa     = require(path.join(__dirname, "./db/anketa"))
const answer     = require(path.join(__dirname, "./db/answer"))
const parents    = require(path.join(__dirname, "./db/parents"))
const statistic  = require(path.join(__dirname, "./db/statistic"))
const jwt        = require(path.join(__dirname, "./db/jwt"))
const validators = require(path.join(__dirname, 'validators.js')).validators

let handlers = {
    v1: {
        get: {
            all: {
                childrenByAnketaId: {
                    handler: async (request, reply) => {
                        const data = {
                            anketa_id: request.params.anketa_id
                        }

                        return children.getByAnketa(data).then(res => {
                            return reply.response(res)
                        })
                    },
                    auth: {
                        strategy: 'jwt'
                    }
                },
                childrenByAnketaAndParent: {
                    handler: async (request, reply) => {
                        const data = {
                            anketa_id: request.params.anketa_id,
                            parents_id: request.params.parents_id
                        }

                        return children.getByAnketaAndParents(data).then(res => {
                            return reply.response(res)
                        })
                    },
                    auth: {
                        strategy: 'jwt'
                    }
                },
                admins: {
                    handler: async (request, reply) => {
                        return parents.getAllAdmins().then(res => {
                            return reply.response(res)
                        })
                    },
                    auth: {
                        strategy: 'jwt'
                    }
                }
            },
            test: {
                handler: async (request, reply) => {
                    return "anketa"
                },
                // auth: {
                //     strategy: 'jwt'
                // }
            },
            anketa: {
                handler: async (request, reply) => {
                    const data = {
                        anketa_id: request.params.anketa_id
                    }
                    return anketa.getById(data).then(data => {
                        return reply.response(data)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            ankety: {
                handler: async (request, reply) => {
                    return anketa.getAll().then(data => {
                        return reply.response(data)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            children: {
                handler: async (request, reply) => {
                    const data = {
                        "parents_id": request.params.parents_id
                    }

                    return children.getByParenets(data).then(data => {
                        return reply.response(data)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            statistic: {
                handler: async (request, reply) => {
                    const data = {
                        anketa_id: request.params.anketa_id,
                        children_id: request.params.children_id
                    }

                    return statistic.get(data).then(data => {
                        return reply.response(data)
                    })
                }, 
                auth: {
                    strategy: 'jwt'
                }
            },
            userByUsername: {
                handler: async (request, reply) => {
                    const username = request.params.username

                    return parents.findByUsername(username).then(data => {
                        return reply.response(data)
                    })
                }, 
                auth: {
                    strategy: 'jwt'
                }
            }
        },
        register: {
            payload: {
                multipart: true
            },
            handler: async (request, reply) => {
                const data = {
                    "first_name"  : request.payload.first_name,
                    "last_name"   : request.payload.last_name,
                    "username"    : request.payload.username,
                    "password"    : request.payload.password,
                    "phone"       : request.payload.phone
                }

                return jwt.register(data).then((data) => {
                    return reply.response(data)
                })
            },
            validate: {
                payload: validators.v1.register,
                failAction: async (request, reply, err) => {
                    throw err
                }
            }
        },
        login: {
            payload: {
                multipart: true
            },
            handler: async (request, reply) => {
                const data = {
                    "username"    : request.payload.username,
                    "password"    : request.payload.password
                }

                return jwt.login(data).then((data) => {
                    return reply.response(data)
                })
            }
        },
        create: {
            admin: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        first_name: request.payload.first_name,
                        last_name: request.payload.last_name,
                        username: request.payload.username,
                        password: request.payload.password
                    }

                    return parents.addAdmin(data).then(res => {
                        return reply.response(res)
                    })
                }
            },
            children: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    let data = {
                        "parents_id": request.payload.parents_id,
                        "name": request.payload.name,
                        "surname": request.payload.surname,
                        "birthday": request.payload.birthday,
                        "weight": request.payload.weight,
                        "height": request.payload.height,
                    }

                    return children.create(data).then(data => {
                        return reply.response(data)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            anketa: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    let data = {
                        "name_of_anketa": request.payload.name_of_anketa,
                        "category": request.payload.category,
                        "sections": request.payload.sections,
                    }

                    return anketa.create(data).then((res) => {
                        return reply.response(res)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            child_answer: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        answers: request.payload.answers
                    }

                    return answer.create(data).then((res) => {
                        return reply.response(res)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            }
        },
        edit: {
            admin: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        admin_id: request.payload.admin_id,
                        first_name: request.payload.first_name,
                        last_name: request.payload.last_name,
                        username: request.payload.username,
                        password: request.payload.password
                    }

                    return parents.editAdmin(data).then(res => {
                        return reply.response(res)
                    })
                }
            },
            children: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    let data = {
                        "children_id": request.payload.children_id,
                        "name": request.payload.name,
                        "surname": request.payload.surname,
                        "birthday": request.payload.birthday,
                        "weight": request.payload.weight,
                        "height": request.payload.height,
                    }

                    return children.edit(data).then(() => {
                        return reply.response({status_code: 200})
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            anketa: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    let data = {
                        anketa_id: request.payload.anketa_id,
                        name_of_anketa: request.payload.name_of_anketa,
                        category: request.payload.category,
                        action: request.payload.action,
                        sections: request.payload.sections,
                        delete: request.payload.delete
                    }

                    return anketa.edit(data).then((data) => {
                        return reply.response(data)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            user: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        first_name: request.payload.check.first_name,
                        last_name: request.payload.check.last_name,
                        username: request.payload.check.username,
                        phone: request.payload.check.phone,
                        parents_id: request.payload.check.parents_id
                    }

                    return parents.edit(data).then(res => {
                        return reply.response(res)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            password: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        parents_id: request.payload.parents_id,
                        password: request.payload.password
                    }

                    return parents.editPassword(data).then(res => {
                        return reply.response(res)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            }
        },
        delete: {
            admin: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        parents_id: request.params.admin_id
                    }

                    return parents.deleteAdmin(data).then(res => {
                        return reply.response(res)
                    })
                }
            },
            children: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        "children_id": request.params.children_id
                    }

                    return children.delete(data).then(() => {
                        return reply.response({status_code: 200})
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            anketa: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    const data = {
                        anketa_id: request.params.anketa_id,
                        delete: request.payload.delete
                    }

                    return anketa.delete(data).then((data) => {
                        return reply.response(data)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            }
        },
        exist: {
            answers: {
                payload: {
                    multipart: true
                },
                handler: async (request, reply) => {
                    let data = {
                        check: request.payload.check
                    }

                    return anketa.hasAnswers(data).then(res => {
                        return reply.response(res)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            },
            user: {
                handler: async (request, reply) => {
                    const data = {
                        parents_id: request.params.parents_id,
                        username: request.params.username
                    }

                    return parents.isExists(data).then(res => {
                        return reply.response(res)
                    })
                },
                auth: {
                    strategy: 'jwt'
                }
            }
        }
    }
}

exports.handlers = handlers