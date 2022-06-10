'use strict'

const path  = require("path")
const nconf  = require('nconf')
const bcrypt = require("bcryptjs")
const pool   = require(path.join(__dirname, "./conn")).pool

let conn

exports.findByUsername = async (username) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const user = await global.conn
        .query("SELECT \
                    parents_id, \
                    first_name, \
                    last_name, \
                    username, \
                    password, \
                    phone, \
                    role, \
                    token \
                FROM \
                    parents \
                WHERE \
                    username = ?", [ username ])
        .then(data => {
            if ( typeof(data[0][0]) !== "undefined" ) {
                return data[0][0]
            } else {
                return null
            }
        })

    return user
}

exports.create = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const { first_name, last_name, username, password, phone, role } = data

    await global.conn
        .query("INSERT INTO \
                    parents (first_name, last_name, username, password, phone, role) \
                VALUES \
                    (?,?,?,?,?,?)", [ first_name, last_name, username, password, phone, role ])
        .catch(err => {
            console.log(err)
        })
}

exports.putToken = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const { username, token } = data

    await global.conn
        .query("UPDATE \
                    parents \
                SET \
                    token = ? \
                WHERE \
                    username = ?",[ token, username ])
        .catch(err => {
            console.log(err)
        })
}

exports.isExists = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const result = await global.conn
        .query("SELECT \
                    count(1) AS exist \
                FROM \
                    parents \
                WHERE \
                    username = ? AND parents_id != ?", [ data.username, data.parents_id ])
        .then(async res => {
            return { exist: res[0][0].exist }
        })
        .catch(err => {
            console.log(err)
            return err
        })

    return result
}

exports.edit = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const result = await global.conn
        .query("UPDATE \
                    parents \
                SET \
                    first_name = ?, \
                    last_name = ?, \
                    username = ?, \
                    phone = ? \
                WHERE \
                    parents_id = ?", [ data.first_name, data.last_name, data.username, data.phone, data.parents_id ])
        .then(async () => {
            return { status_code: 200 }
        })
        .catch(err => {
            console.log(err)
            return err
        })

    return result
}

exports.editPassword = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const encryptedPassword = await bcrypt.hash(data.password, 10)
    const result = await global.conn
        .query("UPDATE \
                    parents \
                SET \
                    password = ? \
                WHERE \
                    parents_id = ?", [ encryptedPassword, data.parents_id ])
        .then(() => {
            return { status_code: 200 }
        })
        .catch(err => {
            console.log(err)
            return err
        })

    return result
}

exports.getAllAdmins = async () => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const result =  await global.conn
        .query("SELECT \
                    parents_id AS id, \
                    first_name, \
                    last_name, \
                    username, \
                    password, \
                    '*****' AS pass_star \
                FROM \
                    parents \
                WHERE \
                    role = 'admin'")
        .then(async res => {
            return res[0]
        })
        .catch(err => {
            console.log(err)
            return err
        })

    return result
}

exports.deleteAdmin = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const children = await global.conn
        .query("SELECT \
                    children_id \
                FROM \
                    children \
                WHERE \
                    parents_id = ?", [ data.parents_id ])
        .then(res => {
            return res[0]
        })
        .catch(err => {
            console.log(err)
            return err
        })

    for (const key in children) {
        const element = children[key]
        await global.conn
            .query("DELETE FROM \
                        children_answer \
                    WHERE \
                        children_id = ?", [ element.children_id ])
            .catch(err => {
                console.log(err)
                return err
            })
    }

    await global.conn
        .query("DELETE FROM \
                    children \
                WHERE \
                    parents_id = ?", [ data.parents_id ])
        .catch(err => {
            console.log(err)
            return err
        })

    const result = await global.conn
        .query("DELETE FROM \
                    parents \
                WHERE \
                    parents_id = ?", [ data.parents_id ])
        .then(() => {
            return { status_code: 200 }
        })
        .catch(err => {
            console.log(err)
            return err
        })

    return result
}

exports.editAdmin = async (data) => {
    let result

    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    if (data.password !== '*****') {
        const encryptedPassword = await bcrypt.hash(data.password, 10)
        result = await global.conn
            .query("UPDATE \
                        parents \
                    SET \
                        first_name = ?, \
                        last_name = ?, \
                        username = ?, \
                        password = ? \
                    WHERE \
                        parents_id = ?", [ data.first_name, data.last_name, data.username, encryptedPassword, data.admin_id ])
            .then(() => {
                return { status_code: 200 }
            })
            .catch(err => {
                console.log(err)
                return err
            })
    } else {
        result = await global.conn
            .query("UPDATE \
                        parents \
                    SET \
                        first_name = ?, \
                        last_name = ?, \
                        username = ? \
                    WHERE \
                        parents_id = ?", [ data.first_name, data.last_name, data.username, data.admin_id ])
            .then(() => {
                return { status_code: 200 }
            })
            .catch(err => {
                console.log(err)
                return err
            })
    }

    return result
}

exports.addAdmin = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const encryptedPassword = await bcrypt.hash(data.password, 10)
    const result = await global.conn
        .query("INSERT INTO \
                    parents (first_name, last_name, username, password, role) \
                VALUES \
                    (?,?,?,?,'admin')", [ data.first_name, data.last_name, data.username, encryptedPassword ])
        .then(res => {
            return res
        })
        .catch(err => {
            console.log(err)
            return err
        })

    return result
}