class tomcat (
  $package_ensure   = $tomcat::params::package_ensure,
  $package_name     = $tomcat::params::package_name,
  $package_provider = $tomcat::params::package_provider,
  $catalina_home    = $tomcat::params::catalina_home,
  $service_name     = $tomcat::params::service_name,
  $service_enable   = $tomcat::params::service_enable,
  $env_base         = $tomcat::params::env_base,
  $tomcat_version   = $tomcat::params::tomcat_version,
) inherits tomcat::params {

  notify {"Running with \$package_name ${package_name} ":}
  notify {"Running with \$service_name ${service_name} ":}

  if $package_ensure {
    if ($package_name == undef or $package_name == '') or
       ($tomcat_version == undef or $tomcat_version == '') {
      fail('You must specify a package_name and tomcat_version if package_ensure is enabled')
    } else {
      if ($package_provider == undef or $package_provider == '') {
        $package_provider = $::osfamily
      }
      if ($package_provider == 'RedHat') {
        if ($catalina_home == undef or $catalina_home == '') {
          $catalina_home = "/usr/share/${package_name}"
        }
        if ($service_name == undef or $service_name == '') {
          $service_name = $package_name
        }
        if ($env_base == undef or $env_base == '') {
          $env_base = '/etc/sysconfig'
        }
      } else {
        if ($catalina_home == undef or $catalina_home == '') or
           ($service_name == undef or $service_name == '') or
           ($env_base == undef or $env_base == '') {
          fail('You must specify catalina_home, service_name and env_base if package_provider is not RedHat')
        }
      }
    }
  }

  class { 'tomcat::install' : } ~>
  class { 'tomcat::service' : }
}
