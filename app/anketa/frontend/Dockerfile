FROM node:16

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

ARG REACT_APP_HOST
ENV REACT_APP_HOST=$REACT_APP_HOST

COPY public public/
COPY src src/

RUN npm run build 
RUN npm i -g serve

EXPOSE 3000
CMD serve -s build