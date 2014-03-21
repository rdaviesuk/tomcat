# see README.md
class tomcat::install inherits tomcat {

  package { 'tomcat':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
