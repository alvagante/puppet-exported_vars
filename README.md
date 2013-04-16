# Puppet module: exported_vars

This module reproduces the behaviour of export resources for variables.

It allows the setting of variables on hosts and their collection on other hosts, enabling easier management of elastic environments where you might not know, upfront, names or ip addresses of hosts or where you have a growing and changing set on nodes.

It has no other modules dependencies but it **requires storeconfigs** on the PuppetMaster.

Written by Alessandro Franceschi / Lab42 and AllOver.IO

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-exported_vars

Released under the terms of Apache 2 License.


## INTRODUCTION

Exported resources are a powerful feature of Puppet that allows the definitions of resources by a node that are applied to other nodes. They are typically used to automate load balancing, monitoring and other functionalities where the configuration of a node depends on other nodes.

This module provides a similar functionality to set variables, based on the values of a node, and use them on other nodes.

It's made of 2 different parts:

* The define **exported_vars::set** , which is used to set variables on a node

* The function **get_exported_var** , which is used on the PuppetMaster to retrieve the values of exported variables and use them on other nodes.

It's based of storeconfigs (nodes actually export file resources which are realized on the PuppetMaster and parsed by the get_exported_var function) and therefore it requires them to be enabled on the PuppetMaster.


## USAGE

This module requires three different (and ordered) steps in order to be effective:

 1 Run Puppet on a node where is set an exported variable (The value can be anything and also, of course, a fact)

        node nagios {
          exported_vars::set { 'monitor_ip':
            value => $::ipaddress
          }
        }

 2 Run Puppet on the PuppetMaster where all the exported variables are collected (as files under the dir /var/lib/puppet/exported_vars) by including the exported_vars class.

        node puppet {
          include exported_vars
        }

 3 Run, finally, Puppet on the node where collected variables have to be used:

        node server {
          $nagios_servers = get_exported_var("","monitor_ip","127.0.0.1")
          class { 'nrpe':
            allow_hosts => $nagios_servers,
          }
        }


* The define **exported_vars::set** just requires a title (the name of the variable to export) and an argument for its value:

        exported_vars::set { 'exported_variable_name':
          value => 'exported_variable_value',
        }


* The function **get_exported_var()** has 3 arguments:

  - The **name/tag of the node** that exported the variable (Leave '' to gather the variable for all the nodes, a name like 'web', gathers also values from nodes whose hostname is 'web', 'web01', 'web02', 'webserver'.., a name like 'web\.' gets only variables from a node whose hostname is 'web')

  - The **name of the exported variable** (as defined by exported_vars::set). Do not use points (.) or slashes (/) in the variable names.

  - The **default value** to return in case no exported variable is found.

The function returns a comma separated list of all the values of the found exported variables, given the above filters (optional node name and variable name).

* All the exported variables are saved, as files, on the PuppetMaster (on in any place where you include exported_vars, but only on the PuppetMaster that's required) under the directory /var/lib/puppet/exported_vars.


