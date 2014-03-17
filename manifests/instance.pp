# see README.md
define tomcat::instance (
  $java_home               = undef,
  $parent_service          = $::tomcat::service_name,
  $env_base                = $::tomcat::env_base,
  $tomcat_version          = $::tomcat::tomcat_version,
  $catalina_home           = $::tomcat::catalina_home,
  $catalina_base           = "/usr/share/${name}",
  $jasper_home             = undef,
  $catalina_tmpdir         = "/usr/share/${name}/temp",
  $java_opts               = undef,
  $catalina_opts           = undef,
  $java_endorsed_dirs      = undef,
  $tomcat_user             = $name,
  $tomcat_group            = $name,
  $tomcat_uid              = undef,
  $tomcat_gid              = undef,
  $tomcat_locale           = undef,
  $enable_security_manager = false,
  $shutdown_wait           = undef,
  $catalina_pid            = "/var/run/${name}.pid",
  $log_base                = "/var/log/${::tomcat::service_name}",
  $tomcat_envfile          = "${::tomcat::env_base}/${name}",
  $service_enable          = true,
  $service_name            = $name,
  $shutdown_port           = 8005,
  $ajp_port                = 8009,
  $http_port               = undef,
  $https_port              = undef,
  $unpack_wars             = true,
  $auto_deploy             = true,
  $access_log_pattern      = undef,
  $uri_encoding            = undef,
  $fragment_host           = undef,
  $fragment_engine         = undef,
  $fragment_service        = undef,
  $fragment_server         = undef,
  $ensure                  = 'present',
) {

  if ! defined(Class['tomcat']) {
    fail('You must include the tomcat base class before using the tomcat::instance resource')
  }

  validate_re($ensure, '^(present|absent)$',
    "${ensure} is not supported for ensure.\n  Allowed values are 'present' and 'absent'.")

  validate_bool($service_enable)

  group { $tomcat_group :
    ensure => $ensure,
    gid    => $tomcat_gid,
  }

  user { $tomcat_user :
    ensure     => $ensure,
    uid        => $tomcat_uid,
    gid        => $tomcat_gid,
    home       => $catalina_base,
    shell      => '/bin/nologin',
    managehome => false,
    require    => Group[ $tomcat_group ],
  }

  file { "/etc/init.d/${service_name}" :
    ensure  => 'link',
    target  => "/etc/init.d/${parent_service}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [
      Class['tomcat'],
    ],
  }

  service { $service_name :
    ensure     => $service_enable,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => File["/etc/init.d/${service_name}"],
  }

  # create catalina_base
  file { $catalina_base :
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
  }

  # create conf, work, webapps, and logdir writeable by tomcat_group
  file { [ "${catalina_base}/conf",
        "${catalina_base}/webapps",
        "${catalina_base}/work",
        "${log_base}/${name}",
        $catalina_tmpdir, ] :
      ensure => directory,
      owner  => 'root',
      group  => $tomcat_group,
      mode   => '0775',
      notify => Service[$service_name],
  }

  file { "${catalina_base}/logs" :
    ensure => link,
    target => "${log_base}/${name}",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    notify => Service[$service_name],
  }

  if ( $catalina_tmpdir != "${catalina_base}/temp" ) {
    file { "${catalina_base}/temp" :
      ensure => link,
      target => $catalina_tmpdir,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      notify => Service[$service_name],
    }
  }

  # setup tomcat env
  file { $tomcat_envfile :
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/tomcat_env.erb"),
    notify  => Service[$service_name],
  }

  # setup server.xml
  file { "${catalina_base}/conf/server.xml" :
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${tomcat_version}/server.xml.erb"),
    notify  => Service[$service_name],
  }

}
