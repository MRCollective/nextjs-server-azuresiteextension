# Next.js Server Azure Site Extension
An Azure Site Extension for hosting Next.js apps built using `next build` where you just need to deploy the .next folder.

All you need to do to deploy a Next.js app to Azure App Service is:

1. Install the nextjs-server site extension (either via the Portal or programmatically via ARM)
2. Run `next build` for your site (e.g. on a build server)
3. Grab the `.next` folder (e.g. as a build artifact)
4. Deploy the `.next` folder to your website

**Note:** If using MsDeploy and you set the option to delete files on the destination that aren't on the source then you will need to set skip rules for `Web.config`, `server.js`, `npm-shrinkwrap.json`, `package.json`, `node_modules`.

## What the extension does

When installed it will add the following files to your `wwwroot` folder:

* `Web.config` - The [standard kudu web.config file for a Node.js app](https://github.com/projectkudu/kudu/wiki/Using-a-custom-web.config-for-Node-apps)
* `server.js` - The entry point for starting the Node.js server and serving the application using Next.js as per [the documentation](https://learnnextjs.com/basics/deploying-a-nextjs-app/deploy-with-a-custom-server)
* `npm-shrinkwrap.json` - Ensures [deterministic npm resolution](https://nodejs.org/en/blog/npm/managing-node-js-dependencies-with-shrinkwrap/)
* `package.json` - Defines the Node.js app and the npm dependencies that need to be resolved

When installed, it will then run `npm install` in your `wwwroot` folder - this can take a few minutes, but only needs to run once when installing the extension (or when upgrading the extension in the future).

The packages installed will be the following (along with their dependencies as per the npm shrinkwrap file):

* "express": "^4.16.2",
* "next": "^4.2.3",
* "react": "^16.2.0",
* "react-dom": "^16.2.0"

## Motivation

When deploying a Next.js app via VSTS RM the [Continuous Delivery](https://github.com/projectkudu/kudu/wiki/VSTS-vs-Kudu-deployments) feature means that Kudu doesn't run it's smarts that will automatically set up the site with the web.config file for Node.js deployments and run npm install for you.

Thus to get your app working you need to deploy all of the files required to run the app, but this includes the node_modules folder with `express`, `next`, `react` and `react-dom` and all of their dependencies, which is over 12k files and this seriously slows down the build and deployment pipeline. In reality you only need these files in the site once so packaging them with every build and deploy doesn't make much sense.

This site extension allows you to delegate the installation of these files to the platform infrastructure. You can programmatically install the extension via ARM (i.e. infrastructure as code) and then all you need to do to get your Next.js app running on Azure is to package and deploy the resultant `.next` folder after running `next build`.

## Todo

* [Add gzip compression and HTTP2 support](https://github.com/zeit/next.js/wiki/Getting-ready-for-production)
* See if it's possible to perform the same function without needing to copy files into `wwwroot` by instead [modifying applicationhost.config via XDT](https://github.com/projectkudu/kudu/wiki/Azure-Site-Extensions)