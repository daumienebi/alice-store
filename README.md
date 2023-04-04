# A L I C E S T O R E -  Json Server
Json server with a fake API to serve the store.
The app is currently using the [json_server](https://github.com/typicode/json-server) to setup a simple api and host it later on Heroku using a very little bit of NodeJs.

## Commands to run / shutdown the server locally
- `npm run server` - to run the server on localhost:3000. To access it from the android emulator or physical device,
    `localhost` needs to be swapped with your `YOUR_IP_ADDRESS`
- `Ctrl + C` to shut down the server. (On Windows)
- `npm install json-server` if you don't have it installed already so that the appropriate `node_modules` files can be generated for your project.

## API Endpoints
- `/products`
- `/project_feeds` - simple details with images about the creation of the project
- `/categories` - The  categories of products

## Resources
- [Download NodeJs](https://nodejs.org/en)
- [Setting up a quick JSON server (RESTful API)](https://medium.com/cbazil-dev/setting-up-a-quick-json-server-restful-api-e5535685c223)
- [Hosting your backend API(JSON-server) on Heroku](https://medium.com/cbazil-dev/hosting-your-backend-api-json-server-on-heroku-1a3b9b3d8f82)
