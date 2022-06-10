# You can containerize this app. 
# The first step you should configure to build frontend and static files will use backend.
FROM node:16

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY src src/
COPY config/server.json config/server.json 

EXPOSE 3000

CMD [ "node", "src/index.js" ]