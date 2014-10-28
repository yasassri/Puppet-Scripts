
# Parameter Class - Define all the parameters in this class
class params {

# General Settings

# File Locations
  $deployment_target  = '/home/yasassri/Desktop/QA_Resources/puppet/DEPLOY/LOCAL'
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

  $config_registry_db_name = 'apim_configdb_puppet'
  $config_db_username  = 'apimuser2'
  $config_db_password  = 'wso2root'

  # Stat DB WSO2AM_STATS_DB

  $stat_registry_db_name = 'apim_statDB_puppet'
  $stat_db_username  = 'apimuser2'
  $stat_db_password  = 'wso2root'

# APIM DB WSO2AM_DB
  $apim_db_name       = 'apimgtdbpuppet'
  $apim_db_username		= 'apimuser2'
  $apim_db_password   = 'wso2root'


# WSO2_Carbon DBs, local DBs for each node

  $gw_manager_carbondb_names  = ['gwmgrcarbondb']
  $gw_manager_carbondb_usernames  = ['apimuser2']
  $gw_manager_carbondb_passwords  = ['wso2root']

  $gw_worker_carbondb_names  = ['gwwrk1carbondb','gwwrk2carbondb']
  $gw_worker_carbondb_usernames  = ['apimuser2','apimuser2']
  $gw_worker_carbondb_passwords  = ['wso2root','wso2root']

  $km_carbondb_names  = ['km1carbondb','km2carbondb']
  $km_carbondb_usernames  = ['apimuser2','apimuser2']
  $km_carbondb_passwords  = ['wso2root','wso2root']

  $publisher_carbondb_names  = ['storecarbondb']
  $publisher_carbondb_usernames  = ['apimuser2']
  $publisher_carbondb_passwords  = ['wso2root']

  $store_carbondb_names  = ['pubcarbondb']
  $store_carbondb_usernames  = ['apimuser2']
  $store_carbondb_passwords  = ['wso2root']


##################LDAP Configuration###################
  $connect_to_ldap  = false # use an external Ldap as the primary user store. The Default JDBC userstore wil not be disconnected in this case.
  $ldap_url         = '192.168.18.76'
  $ldap_port        = '389'
  # Ldap Connection name properties

  $connection_name = 'cn=admin,dc=ITIndustry,dc=sl' # This goes into the user manager.xml
  $rootpartition_string = 'dc=ITIndustry,dc=sl' # This goes into tenent-management.xml

 ################# Dep Sync Configs ###############

  $dep_sync_enabled = true
  $svn_url = 'http://svnexample.wso2.com/svn/yasassri/apimmyrepo/'
  $svn_user_name  = 'wso2'
  $svn_password   = 'wso2123'

  ############### remote Deploying and server startup###############3

  $copy_nodes_to_remote_machines  = false
  $start_up_remote_servers        = false
  $remote_target_directory        = '/home/wso2qa/api-m_puppet'
  $user_name                      = "wso2qa" # This is the OS level username that is required to ssh

##################################
#### KM Related Configs ##########

  # Manager Nodes Parameters only configure following if clustering true for the KM
  $km_manager_offsets             = ['1','6']
  $km_manager_hosts               = ['apim.180.release.km.com','apim.180.release.km.com']
  $km_manager_ips                 = ['10.100.5.112','10.100.5.112']
  $km_manager_local_member_ports  = ['4001','4007']

######################################
##### GateWay Related Configs ########

  $use_management_nodes_as_hybridNode = true

 # Manager Nodes Parameters,,,, only configure following if clustering true for the Gate Way
  $gw_manager_offsets            = ['2']
  $gw_manager_hosts              = ["apim.180.release.gw.manager.com"] # Number of Nodes are determined from the array length
  $gw_manager_ips                = ['10.100.5.112']
  $gw_manager_local_member_ports = ['4003']

# Worker Nodes parameters
  $gw_worker_offsets = ['5','7']
  $gw_worker_hosts = ["apim.180.release.gw.worker.com","apim.180.release.gw.worker.com"] # Number of Nodes are determined from the array length
  $gw_worker_ips = ['10.100.5.112','10.100.5.112']
  $gw_worker_local_member_ports = ['4006','4008']

################################################
############# Publisher Related Configs ########

  $publisher_offsets            = ['3']
  $publisher_hosts              = ['apim.180.release.publisher.com']
  $publisher_ips                = ['10.100.5.112']
  $publisher_local_member_ports = ['4004']

#############################################
########### Store Related Configs ###########

  $store_offsets            = ['4']
  $store_hosts              = ['apim.180.release.store.com']
  $store_ips                = ['10.100.5.112']
  $store_local_member_ports = ['4005']

#######cluster details#########
  $km_domain_name = "apim.release.km.180"
  $gw_domain_name = "apim.release.gw.180"
  $pub_store_domain = "apim.release.storepub.180"

####### ELB Related Configs ########### api-manager.xml

  $elb_host_ip = "10.100.5.112"
  $elb_km_group_mgt_port = "4050"
  $elb_gw_group_mgt_port = "4060"
  $elb_store_pub_group_mgt_port = "4070"

  $km_cluster_domain = "apim.180.release.km.com" # Give the common host name of KM nodes api-manager.xml
  $gw_cluster_domain = "apim.180.release.gw.worker.com" # Give the common host name of gw nodes api-manager.xml
  $cluster_port_https = "443" # elb listner Ports
  $cluster_port_http = "80"

  $http_nio_port  = "81"      # For Request Handling
  $https_nio_port = "444"


 ############BAM Server###################

  $bam_server_ip = "10.100.5.112"
  $bam_port = "7614"
  $bam_server_username = "admin"
  $bam_server_passwd = "admin"

############################################

  $admin_role_name ="Administrator"
  $admin_user_name = "Administrator"
  $admin_passwd = "admin123#"


#########Do Not Change#######

  $gw_manager_nodes = inline_template("<%= @gw_manager_hosts.length %>") #To determine number of manager nodes
  $gw_worker_nodes = inline_template("<%= @gw_worker_hosts.length %>") #To determine number of gw worker nodes
  $km_manager_nodes = inline_template("<%= @km_manager_hosts.length %>") #To determine number of manager nodes


  $configchanges = ['repository/conf/datasources/master-datasources.xml','repository/conf/carbon.xml','repository/conf/registry.xml','repository/conf/user-mgt.xml','repository/conf/axis2/axis2.xml','repository/conf/api-manager.xml','bin/wso2server.sh']
  $gate_way_deployment_configs = ['repository/deployment/server/synapse-configs/default/api/_TokenAPI_.xml','repository/deployment/server/synapse-configs/default/api/_RevokeAPI_.xml','repository/deployment/server/synapse-configs/default/api/_AuthorizeAPI_.xml']
  $km_deployment_configs  = ['repository/conf/tenant-mgt.xml']

}

# Deployment Class
class deploy inherits params {

include km_deploy
include store_deploy
include publisher_deploy
include gw_deploy
include create_loadblnc_conf_configs

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
}

class km_deploy inherits params {

   # Configuring Manager Nodes
    loop{"1":
      count=>$km_manager_nodes,
      setupnode => "km-manager",
      deduct => 0
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

  file {"${params::deployment_target}/elb-configs/axis2.xml":

    ensure => present,
    mode    => '0755',
    content => template("${params::script_base_dir}/templates/elb/axis2.xml.erb"),
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

      path    => '/usr/local/sbin:/usr/localkm_manager_ips/bin:/usr/sbin:/usr/bin:/sbin:/bin', # The search path used for command execution.
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

    if($setupnode == "gw-manager"){

     $local_names2 = regsubst($params::gate_way_deployment_configs, '$', "-$name")

      pushTemplates {$local_names2:
        node_number => $number,
        nodes => $setupnode
      }
}

    # To handle Key Manager related stuff
    if($setupnode == "km-manager" or $setupnode == "km-worker"){

      $local_names3 = regsubst($params::km_deployment_configs, '$', "-$name")

      pushTemplates {$local_names3:
        node_number => $number,
        nodes => $setupnode
      }
   }

    remote_copy{"remote_cpy_$setupnode-$name":
    node_name=>$setupnode,
    node_number=>$number
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

  file {"$params::deployment_target/${nodes}-${node_number}/${orig_name}":

    ensure => present,
    mode    => '0755',
    content => template("${params::script_base_dir}/templates/${nodes}/${orig_name}.erb"),
    require => Exec["Copying_${nodes}-${node_number}"],
  }
}

define remote_copy($node_name,$node_number){

  if($params::copy_nodes_to_remote_machines==true){

    case $node_name {
      gw-manager: {$remote_node_ip = $params::gw_manager_ips[$node_number-1]}
      gw-worker : {$remote_node_ip = $params::gw_worker_ips[$node_number-1]}
      km-manager: {$remote_node_ip = $params::km_manager_ips[$node_number-1]}
      km-worker : {$remote_node_ip = $params::km_worker_ips[$node_number-1]}
      publisher : {$remote_node_ip = $params::publisher_ips[$node_number-1]}
      store     : {$remote_node_ip = $params::store_ips[$node_number-1]}
    }
    remote_copy_start_servers{"Remote_Copy_${node_name}-${node_number}":
      remote_ip=> $remote_node_ip,
      user_name=>"${params::user_name}",
      node_name=>"${node_name}",
      node_number=> "${node_number}"
    }
  }
}

define remote_copy_start_servers($remote_ip,$user_name,$node_name,$node_number){

  exec { "Cpy_to_remote_$node_name-$node_number":
    path    => '/usr/bin:/bin',
    command => "rsync -r ${params::deployment_target}/${node_name}-${node_number} ${user_name}@${remote_ip}:${params::remote_target_directory}",
    require =>  File ["$params::deployment_target/$node_name-${node_number}/repository/conf/api-manager.xml","$params::deployment_target/$node_name-${node_number}/repository/conf/datasources/master-datasources.xml"]
  }

  if($params::start_up_remote_servers==true){

    exec { "Start_servers_$node_name-$node_number":
      path    => '/usr/bin:/bin',
      command => "ssh ${user_name}@${remote_ip} '${params::remote_target_directory}/${node_name}-$node_number/bin/wso2server.sh start'",
      require => Exec["Cpy_to_remote_$node_name-$node_number"]
    }
  }
}

# Package dependencies
package { 'rsync': ensure => 'installed' }

include deploy