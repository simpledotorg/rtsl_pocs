# Generating the documentation

## Prerequisites

Run the docker system so you've got a system running locally

## Install required software.

For this POC we're using SchemaSpy (https://schemaspy.org/). This have the following pre-requisite
- Java
- GraphViz

We'll be using maven to grab SchemaSpy and its dependencies automatically as well as the JDBC driver for Postgresql
- maven

In order to install all that (in Mac OS) , just run:

```
bash install.sh
```

## Generating the automatic Documentation

Simply run

```
bash autodoc.sh
```

# Reading the documentation

Documentation is generated at `./target/htmldoc`. You can navigate into the system from `index.html`.
