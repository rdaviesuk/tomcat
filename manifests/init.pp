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

  if $package_ensure {
    class { 'tomcat::install' : } ~>
    class { 'tomcat::service' : }
  }
}
