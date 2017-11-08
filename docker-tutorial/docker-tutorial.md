---
layout: default
---

_This tutorial is contributed by Hatef Monajemi (@monajemi)_

The following tutorial is intended to familiarize you with building docker images 
and using it. 


# Table of Contents
- [What id Docker](#what-is-docker)
- [How to build a docker image](#how-to-build-docker-a-image) 
- [Using Docker](#using-docker)
    
## What is Docker 

## How to build a docker image

## Using Docker

You can 

* To see a list of your local docker images:
```bash
docker images 
```

* To see a list of your containers:
```bash
docker ps -a 
```

* To reattach your exited conatainer: 

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
