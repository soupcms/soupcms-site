---
tags: [deployment, how-to]
title: Deploying soupCMS website to Heroku
publish_datetime: 2014-05-09T00:00:07.0Z
---

### Create NEW application on [Heroku](https://devcenter.heroku.com/articles/git)

install [Heroku toolbelt](https://toolbelt.heroku.com/) to get started

~~~
$ git init
$ git add .
$ git commit -m 'initial commit'
$ heroku apps:create <heroku-app-name>
~~~

read more [here](https://devcenter.heroku.com/articles/git)

###  Create mongoDB database on [MongoLab](https://mongolab.com/welcome/)

~~~
$ heroku addons:add mongolab
~~~

above command adds mongodb addon from MongoLab to your heroku application.

###  Deploy application to Heroku

repeat this command for every deployment

~~~
$ git push heroku master
~~~

read more [here](https://devcenter.heroku.com/articles/git)

###  Run `soupcms seed` command to import data

repeat this command for every deployment

~~~
$ heroku run bundle exec soupcms seed <app-name> -c
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

