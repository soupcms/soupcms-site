---
tags: [cms, design principles]
---
# Why another CMS?

Using different CMS system on projects varying from heavy weights like Teamsite, Drupal and lightweights like Wordpress or rails based Radiant or LocomotiveCMS. I aways found problems with all these CMS systems is, I had to code my application logic in the way CMS system outlines either as plugins or modules etc.

Why CMS system can't be unobtrusive. Means I want all features of CMS and allows me to code & evolve my application logic as I want. e.g. I have rails application and would like to add CMS as component in it. I can upgrade my rails app without any problem. I faced similar problem, using Radiant CMS with rails 2, 3.2 and 4 all versions.

Also it is difficult to consume data from different or in-house sources. Such as, already have product catalog api available and would like to use it.

So decided to build CMS which is based on following *design principles*.

## Design Principles

- **Unobtrusive** means CMS will integrate within your application as library and provide all CMS features. I can use it with Rails or Sinatra application, without issues. Taking unobstrusive to extend, you can host it like API for other applications to consume it.
- **Dependency Independent**, CMS system should have minimum dependency without any restriction on versions to avoid any conflicts, this allows independent upgradation of the application.
- **Feature Toggle**, not all features is required by everyone. Ability to enable/disable features and based on that reduce dependency. E.g. Enable Markdown processing engine is only required. And by default it is not required so no dependency is added in the system.
- **Multiple source for data**, CMS should be able to consume data from different sources and it should be easy to add new sources easily. Same template can be used to render different data sets.



