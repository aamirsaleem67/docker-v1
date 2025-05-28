FROM node:18-alpine

WORKDIR /src

COPY . .

RUN npm ci

EXPOSE 3000

CMD ["npm", "start"]