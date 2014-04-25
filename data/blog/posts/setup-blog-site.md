---
tags: [setup, how-to]
title: Getting started with soupCMS
publish_datetime: 2014-04-09T00:00:07.0Z
---

## Setup your blog site using soupCMS

> Install soupcms command line gem

~~~
    $ gem install soupcms-cli
~~~

> Run `soupcms new` command to generate skeleton for the blog

~~~
    $ soupcms new <application-name>
~~~

![soupCMS create new blog site](/assets/blog/posts/images/setup-blog-site/soupcms-blog-setup.jpg)
{: .full-width }


> Run `bundle install` command to get all the required gems

~~~
    $ bundle install
~~~


> Run `soupcms seed` command to insert data in mongodb. [How to install MongoDB?](http://docs.mongodb.org/manual/installation/)

~~~
    $ soupcms seed <application-name> -c
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
    $ soupcms post <application-name>
~~~

![soupCMS create new post](/assets/blog/posts/images/setup-blog-site/create-new-post.jpg)
{: .full-width }



