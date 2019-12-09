FROM node:10

# Create app directory
WORKDIR D:\vue\Client

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install 
RUN npm install cross-env -g
RUN npm install webpack-dev-server -g
RUN npm install webpack -g
#RUN npm install webpack --save-dev -gd express --registry=http://registry.npm.taobao.org
#RUN npm install webpack-cli --save-dev -gd express --registry=http://registry.npm.taobao.org
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "npm", "run", "dev" ]