class tomcat::service {

  service { "${tomcat}:service_name" :
    ensure     => $tomcat::service_enable,
    enable     => $tomcat::service_enable,
    hasrestart => true,
    hasstatus  => true,
  }

}
