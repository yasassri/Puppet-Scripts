Puppet Scripts to Deploy ELB fronted ESB Cluster
=================================================

Applicable version : ESB 4.8.0 , ELB 2.1.1

Hoe to run the Scripts
-----------------------

1.  Clone the repository.
2.  Do the required changes in the esb_4.8.0_deploy.pp  file in the param class.
  Note : When specifying the product pack location make sure the product packs are unzipped and the .zip file is not in the same directory.
3.  Specify what are the nodes that is required in the "deploy" Class. For e.g:
    If you need to deploy all the nodes including ELB and ESB. the deploy class will look like following.

class deploy inherits params { <br>
  include esb_deploy  <br>
  include create_loadblnc_conf_configs 
  include deploy_elb 
}

If you don't need a specific node comment-out or remove the lines accordingly.




  
