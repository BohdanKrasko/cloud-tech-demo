'use strict'

const path   = require("path")
const nconf  = require('nconf')
const bcrypt = require("bcryptjs")
const jwt    = require("jsonwebtoken")
const user   = require(path.join(__dirname, "./parents"))

nconf.argv().env().file({file: path.join(__dirname, '..', '..', 'config', 'server.json')})

exports.register = async (data) => {
    try {
        const { first_name, last_name, username, password, phone } = data

        // check if user already exist
        // Validate if user exist in our database
        const oldUser = await user.findByUsername(username)  

        if (oldUser) {
            return {statusCode: 409, message: "User Already Exist. Please Login"}
        }

        //Encrypt user password
        const encryptedPassword = await bcrypt.hash(password, 10)
        // Create token
        const token = jwt.sign(
            { username: username, first_name: last_name, first_name: last_name, phone: phone, role: "user" },
            nconf.get('jwt:secret_key'),
            {
                algorithm: 'HS256',
                expiresIn: "8h"
            }
        )

        const newData = {
            "first_name"  : first_name,
            "last_name"   : last_name,
            "username"    : username,
            "password"    : encryptedPassword,
            "phone"       : phone,
            "role"        : 'user'
        }

        await user.create(newData)
        await user.putToken({username, token})

        return {status_code: 200}
    } catch (err) {
        console.log(err)
        return err
    }
}

exports.login = async (data) => {
    try {
        // Get user input
        const { username, password } = data

        const userData = await user.findByUsername(username)  
        const { first_name, last_name, phone } = userData
    
        if (userData && (await bcrypt.compare(password, userData.password))) {
          // Create token
          const token = jwt.sign(
            { username: username, first_name: first_name, last_name: last_name, phone: phone, role: "user" },
            nconf.get('jwt:secret_key'),
            {
                algorithm: 'HS256',
                expiresIn: '8h'
            }
          )
    
          // save user token
          await user.putToken({username, token})
          userData.token = token
          // user
          return userData
        } else {
            return { statusCode: 400, message: "Invalid user or password" }
        }
    } catch (err) {
        console.log(err)
        return err
    }
}

exports.verifyToken = async (token) => {
    try {
        const data = jwt.verify(token, nconf.get('jwt:secret_key'))
        const userData = await user.findByUsername(data.username)
        if (userData) {
            return { isvalid: true, user: data }
        }
        return {isvalid: false, user: {}}
    } catch (err) {
        return {isvalid: false, user: {}}
    }
}