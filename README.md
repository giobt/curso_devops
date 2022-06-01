# "Introduction to DevOps" workshop
This is a boilerplate project intended to be used as part of a series of courses around DevOps.

## Requirements
* Any flavour of Linux OS for the development environment
* Docker & docker-compose installed

## About the Dockerfile
The repository counts with on simple Dockerfile for a Java Springboot service built using `gradle` and `docker multistage`.
Building the app container will first use a Gradle docker image as base to generate the `jar` file (executable). This artefact is then copied to a docker image containing only the Java runtime environment (JRE).
For more information: [docker multistage official docs](https://docs.docker.com/develop/develop-images/multistage-build/)

## About the database
Using docker, we also enable `postgres` as a relational database engine for showcasing a local development environment, the use of docker volumes, and how to bootstrap the database with scripts on initialization.
For more information: [postgres official docker image](https://hub.docker.com/_/postgres)

## Run the example
Move to the root directory of the repository and run the following commands:
1. Build the app docker image: `docker-compose build`
2. Pull the supporting docker images: `docker-compose pull`
3. Bring up the application: `docker-compose up -d`
To build the container using `docker` instead of `docker-compose` use the following command: `docker build -t dockerbuild/example:latest .`

## Clean-up the resources
Move to the root directory of the repository and run the following command:
1. Bring down the docker-compose stack: `docker-compose down`
