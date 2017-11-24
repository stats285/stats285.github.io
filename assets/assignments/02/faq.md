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


**I have set up my cluster, but there is no GPU accelators that I can use.**

Perhaps you did not edited your GCE qouta for GPU. You need to request GPU quota increase as stated in 
item 9 of [Setup GCE](https://stats285.github.io/assets/assignments/02/assignment2#part-1-setup-google-compute-engine)

**It is taking more than 30 min to build a cluster**   
Have you edited your GPU quota as stated above?
