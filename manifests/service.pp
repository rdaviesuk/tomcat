# see README.md
class tomcat::service inherits tomcat {

  service { $service_name :
    ensure     => $service_enable,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
  }

}
