---
tags: [deployment, how-to]
title: Deploying soupCMS website to Heroku
publish_datetime: 2014-04-09T00:00:07.0Z
---

###  Create mongoDB database on [MongoLab](https://mongolab.com/welcome/)

1. Create new database (Single Node, Sandbox) with database name same as application name. Choose any 'United State' region since Heroku region is going to be 'United States'.

2. Create two users, read-only (username: soupcms) and read/write (username: admin). You can choose different username as well, this is just an example.

3. Get mongoDB url for the database from MongoLab to connect using driver for both the users

~~~
mongodb://<user-name>:<password>@abcdef1234.mongolab.com:12345/<mongolab-database-name>
~~~

### Create NEW application on [Heroku](https://devcenter.heroku.com/articles/git)

~~~
$ git init
$ git add .
$ git commit -m 'initial commit'
$ heroku apps:create <heroku-app-name>
~~~

read more [here](https://devcenter.heroku.com/articles/git)

### Configure mongoDB connection uri using [Heroku configs](https://devcenter.heroku.com/articles/config-vars)

~~~
$ heroku config:set MONGODB_URI_<app-name>=<read-only-mongolab-uri>
~~~

###  Deploy application to Heroku

~~~
$ git push heroku master
~~~

read more [here](https://devcenter.heroku.com/articles/git)

###  Run `soupcms seed` command to import data

~~~
$ (export MONGODB_URI_<app-name>=<read-write-mongolab-uri> && soupcms seed <application-name> -c)
~~~

clean option `-c` does database clean and insert, important while soupCMS is in under heavy development, until v1.0 is release.

### Enable [Google Analytics](http://www.google.co.in/analytics/)

to your blog site by just adding couple of Heroku configs.

~~~
$ heroku config:set google_analytics_application_name_<app-name>=<google-analytics-account-name>
$ heroku config:set google_analytics_tracking_id_<app-name>=<google-analytics-tracking-id>
~~~

In below GA example,

<script src="https://gist.github.com/sunitparekh/11285814.js"></script>

1. `example.com` is the `google-analytics-account-name`
2. `UA-12345678-1` is the `google-analytics-tracking-id`

### Enable [Disqus Commenting](http://disqus.com/)

to your blog site by just adding a Heroku configs.

~~~
$ heroku config:set disqus_shortname_<app-name>=<disqus-shortname>
~~~

