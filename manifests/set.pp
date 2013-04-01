# Define: exported_vars::set
#
# Use this define to set an exported variable from a node
#
define exported_vars::set (
  $value = '',
  ) {

  include exported_vars::params

  @@file { "${exported_vars::params::basedir}/${::fqdn}-${name}":
    content => "${value}\n",
    tag     => 'exported_var',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
  }

}
