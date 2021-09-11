ARG NODE_VER=14.17

FROM node:${NODE_VER}-alpine

WORKDIR /app/apiAuthLDAP

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]


