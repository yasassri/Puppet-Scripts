# Parameter Class - Define all the parameters in this class
class params {

# General Settings

# File Locations
  $deployment_target  = '/home/yasassri/Desktop/QA_Resources/puppet/DEPLOY/tsys'
  $pack_location      = '/home/yasassri/Desktop/soft/WSO2_Products/ESB/esb48'
  $script_base_dir  = inline_template("<%= Dir.pwd %>") #location will be automatically picked up

# MySQL configuration details
  $mysql_server         = 'localhost'
  $mysql_port           = '3306'


# General Database details

#Registry WSO2REGISTRY_DB
  $registry_db_name   	= 'regdb'
  $registry_db_username = 'esbuser2'
  $registry_db_password = 'wso2root'

# user db WSO2UM_DB
  $users_mgt_db_name    = 'umdb'
  $usermgt_db_username  = 'esbuser2'
  $usermgt_db_password  = 'wso2root'

#####################################
###### ESB Related Configs ##########

 # Manager Nodes Parameters only configure following if clustering true for the KM
  $esb_manager_offsets             = ['1']
  $esb_manager_hosts               = ['mgr.esb.tsys.com']
  $esb_manager_ips                 = ['10.100.5.112']
  $esb_manager_local_member_ports  = ['4001']

# Worker Nodes parameters
  $esb_worker_offsets            = ['2','3']
  $esb_worker_hosts              = ['wrk.esb.tsys.com','wrk.esb.tsys.com'] # Number of Nodes are determined from the array length so make it null if worker nodes are not required
  $esb_worker_ips                = ['10.100.5.112','10.100.5.112']
  $esb_worker_local_member_ports = ['4007','4006']

#######cluster details#########
  $esb_clustering_domain     = "esb.cluster.480"

####### ELB Configs #########
  $elb_host_ip  =               "10.100.5.112"
  $esb_cluster_group_mgt_port = "4600"

  $elb_http_port = '8280'
  $elb_https_port = '8243'

  #### Deployment Synchronizer ########

  $dep_sync_enabled = false
  $svn_url  = "http://172.31.35.139/repos/tsys/ESB"
  $svn_username = "wso2"
  $svn_passwd = "wso2123"

 #########Do Not Change#######

  $esb_manager_nodes = inline_template("<%= @esb_manager_hosts.length %>") #To determine number of manager nodes
  $esb_worker_nodes = inline_template("<%= @esb_worker_hosts.length %>") #To determine number of worker nodes

  $configchanges = ['conf/datasources/master-datasources.xml','conf/carbon.xml','conf/registry.xml','conf/user-mgt.xml','conf/axis2/axis2.xml']

}

# Deployment Class
class deploy inherits params {

  include esb_deploy
  include create_loadblnc_conf_configs

}

class esb_deploy inherits params {

# Configuring Manager Nodes
  loop{"1":
    count=>$esb_manager_nodes,
    setupnode => "manager",
    deduct => 0

  }

#Configuring worker Nodes
  $newval= $esb_manager_nodes+2 #to avoid resource duplication

  loop {$newval:
    count=>$esb_worker_nodes+$newval-1,
    setupnode => "worker",
    deduct => $newval-1

  }
}

class create_loadblnc_conf_configs inherits params {

  file {"${params::deployment_target}/elb-configs":
    ensure => directory;
  }

  file {"${params::deployment_target}/elb-configs/load_balancer_configs.xml":

    ensure => present,
    mode    => '0755',
    content => template("${params::script_base_dir}/templates/elb/load_balancer_configs.xml.erb"),
    require => File["${params::deployment_target}/elb-configs"],
  }
}

# Loop for Spawning Members
define loop($count,$setupnode,$deduct) {

  if ($name > $count) {
    notice("Loop Iteration Finished!!!\n")
  }
  else
  {
    notice("########## Configuring ${setupnode} Nodes!!##############\n")

    $number = $name - $deduct
    file {"${params::deployment_target}/$setupnode-$number":
      ensure => directory;
    }

  #copying the Files (packs)
    exec { "Copying_$setupnode-$number":

      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', # The search path used for command execution.
      command => "cp -r ${params::pack_location}/wso2esb-*/* ${params::deployment_target}/$setupnode-$number/",
      require => File["${params::deployment_target}/$setupnode-$number"],
    }

  # Copying Patches
    copy_files{"Cpy_patches_$setupnode-$number":
      from => "${params::script_base_dir}/libs/patches/",
      to   => "${params::deployment_target}/$setupnode-$number/repository/components/patches/",
      node_name=> "$setupnode-$number",
      unq_id=> "patches"
    }
  # Copying DB Drivers
    copy_files{"Cpy_drivers_$setupnode-$number":
      from => "${params::script_base_dir}/libs/db_drivers/",
      to   => "${params::deployment_target}/$setupnode-$number/repository/components/lib/",
      node_name=> "$setupnode-$number",
      unq_id=> "db_drivers"
    }

    $local_names = regsubst($params::configchanges, '$', "-$name")

    pushTemplates {$local_names:
      node_number => $number,
      nodes => $setupnode
    }

    $next = $name + 1
    loop { $next:
      count => "${count}",
      setupnode => "${setupnode}",
      deduct=>"${deduct}",
    }
  }
}

define copy_files($from,$to,$node_name,$unq_id){

  exec { "Cpy_${unq_id}_$node_name":
    path    => '/usr/bin:/bin',
    command => "rsync -r $from $to",
    require => [
      File["${params::deployment_target}/$node_name"],
      Package['rsync'],
      Exec["Copying_$node_name"]
    ],
  }
}

define pushTemplates($node_number,$nodes) {

  $orig_name = regsubst($name, '-[0-9]+$', '')

  file {"$params::deployment_target/${nodes}-${node_number}/repository/${orig_name}":

    ensure => present,
    mode    => '0755',
    content => template("${params::script_base_dir}/templates/${nodes}/${orig_name}.erb"),
    require => Exec["Copying_${nodes}-${node_number}"],
  }
}

# Package dependencies
package { 'rsync': ensure => 'installed' }

include deploy
