---
layout: default 
---

# Frequently Asked Questions (FAQ)


1. **I have set up my cluster, but there is no GPU accelators that I can use.**

   Perhaps you did not edit your GCE qouta for GPU. You need to request an increase in GPU quota as stated in 
item 9 of [Setup GCE](https://stats285.github.io/assets/assignments/02/assignment2#part-1-setup-google-compute-engine)

1. **It is taking more than 30 min to build a cluster**   
   Have you edited your GPU quota before you run `elasticluster -vvv start gce` as stated above in item 2?

1. **I have received two credits from Google Education grants that created two billing accounts. How can I use both for my project?**    
   You can change your project's billing account by going to [Billing Page](https://console.cloud.google.com/billing). You can associate a different billing account to your project as shown below.   

   ![GCE Billing](../../img/billing-change.png) 
