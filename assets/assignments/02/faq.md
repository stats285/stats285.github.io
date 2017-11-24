---
layout: default 
---

# Frequently Asked Questions (FAQ)


1. **I do not know how to stop my `gce` cluster now that I accidentally closed the terminal with the original docker image.**   

    There are two ways to stop your cluster:      
        1. reattach container to your terminal:
            ```
            # find your container-id    
            docker ps -a    
            docker start -a -i <container-id>   
            elasticluster stop gce
            ```     
        2. login to [google consol](https://console.cloud.google.com) and delete your instances.
