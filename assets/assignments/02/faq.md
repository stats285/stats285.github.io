---
layout: default 
---

# Frequently Asked Questions (FAQ)


**I do not know how to stop my `gce` cluster now that I accidentally closed the terminal with the original docker container.**   

When you close the terminal, the container is still running in the background. There are two ways you can stop your cluster:  

 1. re-attach container to your terminal:    
    ```
    # find your container-id    
    docker ps -a    
    docker start -a -i <container-id>   
    elasticluster stop gce
    ```     
 2. login to [google compute consol](https://console.cloud.google.com/compute) and delete your instances.
