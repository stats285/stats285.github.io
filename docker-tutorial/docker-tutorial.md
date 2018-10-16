---
layout: default
---

_This tutorial is contributed by Hatef Monajemi (@monajemi)_

The following tutorial is intended to familiarize you with building docker images 
and using them. 


# Table of Contents
- [What is Docker](#what-is-docker)
- [How to build a docker image](#how-to-build-docker-a-image) 
- [Using Docker](#using-docker)
    
## What is Docker 

## How to build a Docker image

## Using Docker


* To see a list of your local docker images:
```bash
docker images 
```

* To get into a docker image (say `riccardomurri/elasticluster`) that may have a different entrypoint that bash
```bash
docker run -it --entrypoint /bin/bash riccardomurri/elasticluster
```

* To see a list of your containers:
```bash
docker ps -a 
```

* To reattach your exited container: 
```bash
docker start  <IMAGE_ID>
docker attach <IMAGE_ID>
```
or simply,
```bash
docker start -a -i <IMAGE_ID>
```
> This is a great command to remember, since you may exit your terminal, but this command allows you to start the exited containers and attach to the terminal again. 




[back](../notes)
