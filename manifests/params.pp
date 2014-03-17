# see README.md
class tomcat::params {

  $package_ensure = 'present'
  $service_enable = false

  case $::osfamily {
    'RedHat': {
      if $::operatingsystem != 'Fedora' {
        if is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease == 3 {
          $package_name   = 'tomcat5'
          $tomcat_version = 5.0
        }
        elsif is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease == 4 {
          $package_name   = 'tomcat5'
          $tomcat_version = 5.5
        }
        elsif is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease == 5 {
          $package_name   = 'tomcat5'
          $tomcat_version = 5.5
        }
        elsif is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease == 6 {
          $package_name   = 'tomcat6'
          $tomcat_version = 6.0
        }
        elsif is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease == 7 {
          $package_name   = 'tomcat'
          $tomcat_version = 7.0
        }
      }
      else {
        if is_integer($::operatingsystemmajrelease) and 2 >= $::operatingsystemmajrelease <= 4 {
          $package_name   = 'tomcat5'
          $tomcat_version = 5.0        }
        elsif is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease <= 8 {
          $package_name   = 'tomcat5'
          $tomcat_version = 5.5
        }
        elsif is_integer($::operatingsystemmajrelease) and $::operatingsystemmajrelease <= 14 {
          $package_name   = 'tomcat6'
          $tomcat_version = 6.0
        }
        else {
          $package_name   = 'tomcat'
          $tomcat_version = 7.0
        }
      }
      $catalina_home    = "/usr/share/${package_name}"
      $service_name     = $package_name
      $package_provider = $::osfamily
      $env_base         = '/etc/sysconfig'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
