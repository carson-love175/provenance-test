# Build Stage
FROM node:14 AS build
RUN mkdir -p usr/src/app
COPY *.js /usr/src/app
#COPY *.json /usr/src/app
COPY tests/ /usr/src/app
WORKDIR /usr/src/app
# RUN Stage 
RUN npm init -y
RUN npm install npm@6
copy . .
LABEL repository-name="DEV-JavaScriptTestApp"
LABEL owner="Mora-Matthew_mclm"
CMD [ "node", "server.js" ]
