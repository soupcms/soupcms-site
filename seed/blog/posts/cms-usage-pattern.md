# CMS usage patterns, find out which one fits yours need?

Now days every business wants CMS capability in their app, at minimum for home page to show promotions, alerts, news & messages to end users. On each and every project I have been on in last 5 odd years, CMS was part of application in one or the other way. At the start of the project I always had to think and decide which CMS system should I go for. And working with different domain, some patterns started emerging in my thoughts and helped me making decision.
I have worked with multiple feature rich CMS products, which provides business critical features such as versioning, publishing work flow, content promotion... . However, one of the key pain area in all of this feature rich CMS products is that development of remaining custom components either as plugins or customization modules if very difficult. Developing these ~20% of the custom components takes lot of time & effort with specialized skills. Most of the time we need to hack to get custom component build in existing CMS.

## Based on usage pattern of the CMS, categorised into following CMS usage pattern?

### Type 1: Full CMS
In this category of CMS usage, full website is build using CMS. All content is published and managed within CMS. There are number of editors whose job is to manage and maintain the content on website. Hence, CMS should have capability of managing and generating content. The content is edited, created frequently on website by multiple users as full time job.
#### examples: News sites, Company or corporate websites


### Type 2: Partial CMS
Here the site required lot of content to be CMS managed like product details, promotions on site (e.g. deal of the day), special deals etc. However, there is log of application logic apart from CMS systm such as shopping cart, payment, checkout etc.
#### examples: Retail websites


### Type 3: CMS for the namesake
#### examples: About, Contact, Legal ... pages in any website


First, find out what is the usecase and decide on the cMS system you are looking for.

And I started looking into following criteria while choosing CMS:
* Support for digital asset management (image repository with resizing) are very important for CMS. Look for Amazon S3 support too.
* Content promotion from non-production env to production env is one of the most used feature. e.g. Create all the required content in stage and promote it to production before launch. Gives more flexibility to push release early to stage and get the content ready and later deploy and publish content in one go to production.
* How much specialised knowledge required for CMS system? or just good programming knowledge is enough? Most of the CMS doesn't integrate seamlessly in your application. Application needs to be developed within CMS. So now while choosing CMS I started looking into how easy or difficult it is to develop custom features/components within CMS.
* Free text search has become 'de facto' requirement now days for any website. And hence more critical feature for CMS to have. Don't forget to try and see how good SEO support and inbuilt search is. This could become make and break deal for some business while choosing CMS.
* Be aware of oversold CMS features which are hardly used in production.  Work flow management within CMS. Sounds good but practically what end user wants is just the option to preview (as review mode) and publish.
* Does CMS support mobile first, responsive design and responsive images.

My take? just build what you need. initial investment will be more but it will save on customization, learning & lot with maintenance cost later. Spend time in development rather than learning, researching and hacking into CMS product.

Hope this article helps you in deciding your next CMS system.