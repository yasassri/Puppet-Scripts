
# Parameter Class - Define all the parameters in this class
class params {

# General Settings

# File Locations
  $deployment_target  = '/home/yasassri/Desktop/QA_Resources/puppet/DEPLOY'
  $pack_location      = '/home/yasassri/Desktop/soft/WSO2_Products/API_Manager/new'
  $script_base_dir  = inline_template("<%= Dir.pwd %>") #location will be automatically picked up

# DB Configurations
  $db_type = "mysql" #add keyword "oracle" or "mysql"

# MySQL configuration details
  $mysql_server         = 'localhost'
  $mysql_port           = '3306'

# Oracle DB detailes
  $oracle_server         = '192.168.10'
  $oracle_port           = '3306'

# General Database details

#Registry WSO2REGISTRY_DB
  $registry_db_name   	= 'apiregdbpuppet' # For oracle this would be the main DB name
  $registry_db_username = 'apimuser2'       # For oracle this is the user schema
  $registry_db_password = 'wso2root'        # For oracle this schema password

# user db WSO2UM_DB
  $users_mgt_db_name    = 'apiuserdbpuppet'
  $usermgt_db_username  = 'apimuser2'
  $usermgt_db_password  = 'wso2root'

  # Config Registry - WSO2CONFIGREG_DB

  $config_registry_db_name = 'testDB'
  $config_db_username  = 'apimuser2'
  $config_db_password  = 'wso2root'

  # Stat DB WSO2AM_STATS_DB

  $stat_registry_db_name = 'statDB'
  $stat_db_username  = 'apimuser2'
  $stat_db_password  = 'wso2root'

# APIM DB WSO2AM_DB
  $apim_db_name       = 'apimgtdbpuppet'
  $apim_db_username		= 'apimuser2'
  $apim_db_password   = 'wso2root'

##################################
#### KM Related Configs ##########

  $km_clustering = true # to create worker Manager Nodes for Key Manager

  # Manager Nodes Parameters only configure following if clustering true for the KM
  $km_manager_offsets             = ['1']
  $km_manager_hosts               = ['km-manager-test.com']
  $km_manager_ips                 = ['100.100.5.112']
  $km_manager_local_member_ports  = ['4000']

  # Worker Nodes parameters
  $km_worker_offsets            = ['2']
  $km_worker_hosts              = ['km-worker-test.com']
  $km_worker_ips                = ['100.100.5.112']
  $km_worker_local_member_ports = ['4001']

######################################
##### GateWay Related Configs ########

  $gw_clustering = true # to create worker Manager Nodes for Key Manager

# Manager Nodes Parameters,,,, only configure following if clustering true for the Gate Way
  $gw_manager_offsets            = ['1','2']
  $gw_manager_hosts              = ["manager.test.com"]
  $gw_manager_ips                = ['100.100.5.112', '100.5.2.3']
  $gw_manager_local_member_ports = ['4000','4001']

# Worker Nodes parameters
  $gw_worker_offsets = ['1','2']
  $gw_worker_hosts = []
  $gw_worker_ips = ['100.100.5.112','100.5.2.3']
  $gw_worker_local_member_ports = ['4005','4006']


#### Publisher Related Configs ########
  $publisher_offsets            = ['1']
  $publisher_hosts              = ['km-manager-test.com']
  $publisher_ips                = ['100.100.5.112']
  $publisher_local_member_ports = ['4002']


###### Store Related Configs ########
  $store_offsets            = ['1']
  $store_hosts              = ['storehost-test.com']
  $store_ips                = ['100.10.5.112']
  $store_local_member_ports = ['4003']

#######cluster details#########
  $km_domain_name = "apim.km.171"
  $gw_domain_name = "apim.gw.171"
  $pub_store_domain = "apim.171"

####### ELB Related Configs ########### api-manager.xml

  $elb_host_ip = "192.15.12.222"
  $elb_port = "4005"
  $km_cluster_domain = "apim.km.com"
  $cluster_port_https = "443"
  $cluster_port_http = "80"
  $gw_cluster_domain = "apim.gw.com"

 ############BAM Server###################

  $bam_server_ip = "10.100.5.45"
  $bam_port = "7614"
  $bam_server_username = "admin"
  $bam_server_passwd = "admin"


############################################

  $admin_role_name ="Administrator"
  $admin_user_name = "Administrator"
  $admin_passwd = "admin123#"


######### Config Files to be Changed ###########

  $configchanges = ['conf/datasources/master-datasources.xml','conf/carbon.xml','conf/registry.xml','conf/user-mgt.xml','conf/axis2/axis2.xml']

}

# Deployment Class
class deploy inherits params {

#include km_deploy
#include store_deploy
#include publisher_deploy
include gw_deploy

}

class publisher_deploy inherits params {

 loop{"301":
    count=>301,
    setupnode => "publisher",
    deduct => 300
  }

}

class store_deploy inherits params{

  loop{"201":
    count=>201,
    setupnode => "store",
    deduct => 200
  }
}

class gw_deploy inherits params {
    if($gw_clustering == true){

      $gw_manager_nodes = inline_template("<%= @gw_manager_hosts.length %>") #To determine number of manager nodes
      $gw_worker_nodes = inline_template("<%= @gw_worker_hosts.length %>") #To determine number of manager nodes

    # Configuring Manager Nodes
      loop{"101":
        count=>$gw_manager_nodes+100,
        setupnode => "gw-manager",
        deduct => 100

      }

    #Configuring worker Nodes
      $newval2= $gw_manager_nodes+2 +101 #to avoid resource duplication

      loop {$newval2:
        count=>$gw_worker_nodes+$newval2-1,
        setupnode => "gw-worker",
        deduct => $newval2-1

      }

    } else {

      file {"$deployment_target/gw-1":
        ensure => directory;
      }

      exec { "Copying_gw_Files":

        path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', # The search path used for command execution.
        command => "cp -r $pack_location/wso2am-*/* ${deployment_target}/gw-1/",
        require => File["$deployment_target/gw-1"],

      }

      $local_names3 = regsubst($configchanges, '$', "-1126")
      pushTemplates{$local_names3: node_number=>0, nodes=>"gw"}
  }
}

class km_deploy inherits params {
  if($km_clustering == true){

    $km_manager_nodes = inline_template("<%= @km_manager_hosts.length %>") #To determine number of manager nodes
    $km_worker_nodes = inline_template("<%= @km_worker_hosts.length %>") #To determine number of manager nodes

    # Configuring Manager Nodes
    loop{"1":
      count=>$km_manager_nodes,
      setupnode => "km-manager",
      deduct => 0

    }

    #Configuring worker Nodes
    $newval= $km_manager_nodes+2 #to avoid resource duplication

    loop {$newval:
      count=>$km_worker_nodes+$newval-1,
      setupnode => "km-worker",
      deduct => $newval-1

      }

  } else { # if worker manager not being created

    file {"$deployment_target/km":
          ensure => directory;
        }

     exec { "Copying_gw_Files":

     path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', # The search path used for command execution.
     command => "cp -r $pack_location/wso2am-*/* ${deployment_target}/km/",
     require => File["$deployment_target/km"],
     }
  }
}

# Loop for Managers

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
      command => "cp -r ${params::pack_location}/wso2am-*/* ${params::deployment_target}/$setupnode-$number/",
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
#package{'rsync2':}