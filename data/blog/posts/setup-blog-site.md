---
tags: [deployment, getting-started]
title: Getting started with soupCMS
publish_datetime: 2014-04-09T00:00:07.0Z
---

## Setup your blog using 5 simple steps

> Install soupcms command line gem

~~~
    $ gem install soupcms-cli
~~~

> Run `soupcms new` command to generate skeleton for the blog

~~~
    $ soupcms new <blog-name>
~~~

![soupCMS create new blog site](/assets/blog/posts/images/setup-blog-site/soupcms-blog-setup.png)
{: .full-width }

> Run `soupcms seed` command to insert data in mongodb. [How to install MongoDB?](http://docs.mongodb.org/manual/installation/)

~~~
    $ soupcms seed <blog-name>
~~~

> Start you blog service locally, using puma web server running on default port 9292

~~~
   $ bundle exec puma
~~~

> Open [http://localhost:9292/home](http://localhost:9292/home) URL in browser

******

## How to add new post?

> Run `soupcms post` command to generate skeleton for the blog

~~~
    $ soupcms new <blog-name>
~~~




