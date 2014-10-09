Puppet Scripts to Deploy ELB fronted ESB Cluster
=================================================

Applicable version : ESB 4.8.0 , ELB 2.1.1

What the Script can do
----------------------

The script can deploy an ELB fronted ESB cluster. The user can specify the number of worker manager nodes that are required, The script can deploy both ELB and ESB nodes. The deployment will use mysql configurations. 

What the Script Cannot do
-------------------------

->The script cannot create required DBs automatically.<br>
->The script cannot Spawn nodes to remote machines. (This is feature will be added)
->The script will not add required entried to to /etc/hosts File. 

How to run the Scripts
-----------------------

1.  Clone the repository.
2.  Do the required changes in the esb_4.8.0_deploy.pp  file in the param class.<br>
  <i>Note : When specifying the product pack location make sure the product packs are unzipped and make sure the .zip files are not in the same directory.</i><br>
3.  Specify what are the nodes that is required in the "deploy Class". For e.g:
    If you need to deploy all the nodes including ELB and ESB. the deploy class will look like following.

class deploy inherits params { <br>
  include esb_deploy  <br>
  include create_loadblnc_conf_configs <br>
  include deploy_elb <br>
}

If you don't need a specific node comment-out or remove the lines accordingly.

4.  Now run the script with the following command "puppet apply esb_4.8.0_deploy.pp"
5.  Now add the necessary entries to etc/hots file and start the servers.




  
