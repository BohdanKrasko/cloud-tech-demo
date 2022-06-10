'use strict'

const path = require("path")
const nconf = require('nconf')
const mysql = require('mysql2')

nconf.argv().env().file({file: path.join(__dirname, '..', '..', 'config/server.json')})

// create the connection to database
exports.pool = mysql.createPool({
    host: nconf.get('db:host'),
    user: nconf.get('db:username'),
    password: nconf.get('db:password'),
    database: nconf.get('db:database'),
    port:  parseInt(nconf.get('db:port')),
    waitForConnections: true,
    connectionLimit: nconf.get('db:connection_limit'),
    queueLimit: 0
})