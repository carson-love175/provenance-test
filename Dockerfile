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
LABEL repository-name="carson-love175/provenance-test"
LABEL owner="First Last"
CMD [ "node", "server.js" ]
