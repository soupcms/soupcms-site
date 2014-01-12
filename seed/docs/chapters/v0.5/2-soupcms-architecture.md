# Architecture

## High level system architecture diagram

![soupCMS High level system architecture diagram](/assets/docs/chapters/images/soupcms-architecture.svg "soupCMS High level system architecture diagram")

### soupCMS Core

- resolves requested URL to it's page and model
- builds page using modules defined in page
- builds modules with data fetched using recipes

### soupCMS API

- provides API to fetch models from mongoDB
- enhances model data as
    - **enrich**, enhances the model with more information e.g. building URL for each model
    - **resolve**, resolves the data inside model e.g. resolve reference models, resolve markdown to HTML content, resolve link references

### soupCMD mongoDB Database

- stores user defined & soupCMS core models
- soupCMS core models are pages, templates

### Internal or External Data Sources

Use your internal or external services to fetch data using recipe. Data can be fetched from any soure, post processed and mapped to required format by modules.

### Responsive Image Server

Host images on one of the Digital Asset Management solutions such as Adobe Scene7, cloudinary.com or cdnconnect.com. soupCMS modules can render responsive images using such image server.

### soupCMS Admin

> to be developed as last part of v1.0 release

- admin interface to manage model data in database
- user friendly UI to edit model data (forms based)
- role based model access rights


### soupCMS Rake

> alternate till "soupCMS Admin" is developed

Rake tasks to populate models in database (command line admin interface)



_____




## High level sequence diagram of soupcms workflow

![soupCMS High level system architecture diagram](/assets/docs/chapters/images/soupcms-sequence-diagram.svg "soupCMS High level system architecture diagram")
