Puppet Scrits to Deploy ELB Fronted API-M Cluster
==================================================

What the script can do.
---------------------

* The script can spawn ELB fronted API-M cluster with any number of GW and KM worker/manager nodes.
* Supports both mysql and Oracle DB types.
* Script can automatically setup the primary userstore to an LDAP or RDBMS
* Can automatically copy patches and drivers to all the nodes. 

How to use the script
-----------------------

Install Puppet agent (do not need puppet master) make sure you install version 3+.
Clone the repository and do the necessary parameter changes in the params class.
Execute the script "puppet apply init.pp"

Note:

If you do not need any worker nodes make sure worker_host name array doesn't have any content.
You can comment one of the following lines if you do not need a specific node to spawn

include km_deploy
include store_deploy
include publisher_deploy
include gw_deploy

If the deployment target has any previous deploys the script will override the existing content. So its better to make sure you clean the deployment folder before executing the script.

