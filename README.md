node-scheduler-demo
===================

Demo of ULL Calendar with NodeJs + MongoDB as backend

### How to start

To run the app, do the next after cloning the repo

~~~
npm install
node app.js
~~~

After that, open in a browser using Bluemix
To generate a single test event, hit <bluemix path>/init to populate a single event into the calendar. 

### DB config

App expects to find the mongoDB on localhost, you can change the server address in the app.js 

## Deploy pipeline

We use a series of different "manifest_xxx.yml" files to allow us to deploy this application to multiple environments and instances in the Bluemix staging area.  In the deployment pipeline, we only do a deployment to the TestCalendar instance on a code change.  Deployments to the other target instances need to be initiated from the Deployment pipeline screen manually.  Right now, we support three different environments:
* TestCalendar - our testing instance, auto-deployed on build success
* ULLCloudCalendar - manually deployed, this is the ULL Cloud team calendar
* WWGarageCalendar - manually deployed, this is the calendar for the WW Bluemix garage org.

The different manifest files are copied into "manifest.yml" prior to the "cf push", which allows us to change the backend DB's used and the instance names for each of these instances.

## Files

The Node.js starter application has files as below:

* app.js

	This file contains the server side JavaScript code for your application
	written using the express server package.

* public/

	This directory contains public resources of the application, that will be
	served up by this server

* package.json

	This file contains metadata about your application, that is used by both
	the `npm` program to install packages, but also Bluemix when it's
	staging your application.  For more information, see:
	<https://docs.npmjs.com/files/package.json>

[![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/dtoczala/ULLCloudCalendar.git/)