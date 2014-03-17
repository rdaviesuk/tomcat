# see README.md
class tomcat::install {

  package { 'tomcat':
    ensure => $tomcat::package_ensure,
    name   => $tomcat::package_name,
  }

}
