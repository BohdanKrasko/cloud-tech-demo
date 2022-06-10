'use strict'

const path  = require("path")
const nconf = require('nconf')
const pool  = require(path.join(__dirname, "./conn")).pool

let conn

exports.create = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }

    const children_id = data.answers[0].children_id
    const date = new Date()

    for (const key in data.answers) {
        let element = data.answers[key]
        await global.conn
            .query('INSERT INTO \
                        children_answer (children_id, list_of_answer_id, question_id, date) \
                    VALUES \
                        (?,?,?,?)', [ children_id, element.list_of_answers_id, element.question_id, date ])
            .catch(err => {
                console.log(err)
                return err
            })
    }

    return { status_code: 200 }
}