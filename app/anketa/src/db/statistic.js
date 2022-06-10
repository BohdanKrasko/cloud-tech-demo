'use strict'

const path  = require("path")
const nconf = require('nconf')
const pool  = require(path.join(__dirname, "./conn")).pool

let conn

exports.get = async (data) => {
    if (pool._allConnections.length < nconf.get('db:connection_limit')) {
        conn =  await pool.promise().getConnection()
        global.conn = conn
    }
    
    const result = await global.conn
        .query("SELECT \
                    anketa.anketa_id, \
                    anketa.name_of_anketa, \
                    section.section_id, \
                    section.name_of_section, \
                    question.question_id, \
                    question.question, \
                    list_of_answers.list_of_answers_id, \
                    list_of_answers.name_of_answer, \
                    children_answer.date, \
                    children.name, \
                    children.surname, \
                    parents.first_name, \
                    parents.last_name, \
                    parents.phone \
                FROM \
                    anketa \
                INNER JOIN section ON anketa.anketa_id = section.anketa_id \
                INNER JOIN question ON section.section_id = question.section_id \
                INNER JOIN children_answer ON question.question_id = children_answer.question_id \
                INNER JOIN children ON children_answer.children_id = children.children_id \
                INNER JOIN parents ON children.parents_id = parents.parents_id \
                INNER JOIN list_of_answers ON children_answer.list_of_answer_id = list_of_answers.list_of_answers_id \
                WHERE \
                    anketa.anketa_id = ? AND children.children_id = ? \
                GROUP BY \
                    children_answer.date, \
                    section.section_id, \
                    question.question_id, \
                    list_of_answers.list_of_answers_id, \
                    children.children_id \
                ORDER BY \
                    children_answer.date", [ data.anketa_id, data.children_id ])
        .then(res => {
            return res[0]
        }).catch(err => {
            console.log(err)
            return err
        })

    return result
}

