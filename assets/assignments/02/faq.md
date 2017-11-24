---
layout: default 
---

# Frequently Asked Questions (FAQ)


**I do not know how to stop my `gce` cluster now that I accidentally closed the terminal with the original docker container.**   

There are two ways you can stop your cluster:  

 1. reattach container to your terminal:    
            
        ```
        # find your container-id    
        docker ps -a    
        docker start -a -i <container-id>   
        elasticluster stop gce
        ```     
 2. login to [google consol](https://console.cloud.google.com) and delete your instances.