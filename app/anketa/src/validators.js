'use strict'

const Joi = require('joi')

const validators = {
    v1: {
        register: Joi.object().keys({
            first_name: Joi.string().required(),
            last_name: Joi.string().required(),
            username: Joi.string().required(),
            password: Joi.string().required(),
            phone: Joi.string().required()
        }),
        login: Joi.object().keys({
            username: Joi.string().required(),
            password: Joi.string().required(),
        })
    }
}

exports.validators = validators
