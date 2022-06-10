let config = { 
  "host": "0.0.0.0",
  "port": 3000,
  "db": {
      "host": "db-stage-irc",
      "username": "user",
      "database": "anketa",
      "password": "user",
      "port": 3306,
      "connection_limit": 8
  },
  "jwt": {
      "secret_key": "TOKEN_KEY"
  }
};

exports.config = config