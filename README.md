tomcat
======

## Overview

A Puppet module for managing Tomcat instances.

## Description

This module is intended for installing tomcat, and creating tomcat
instances.

It allows for a reasonable amount of flexibility in the instance
config, but does not handle deployment of application code, and nor
does it handle instance-specific config files other than server.xml and
sysconfig/<instance-name>.

It does not directly handle installing java, although installing a
tomcat package will normally cause java to be installed as a
dependency.  To use different versions of Java, the JAVA_HOME can be
set for each instance, although you will need to handle the install of
that version of Java.

## Compatibility

This module is currently aimed at the RHEL packaged versions of Tomcat,
and relies on the RHEL init script to create tomcat instance services.

It has only been tested on RHEL6/CentOS6 with the base OS tomcat6 and
EPEL testing tomcat (7) packages so far.

## Usage

To install the base OS tomcat package (the module will try to figure
out the details based on the OS, see params.pp):


```puppet
  class { '::tomcat': }
```

To specify a particular tomcat package:

```puppet
  class { '::tomcat':
    package_name   => 'tomcat',
    service_name   => 'tomcat',
    tomcat_version => '7.0',
    catalina_home  => '/usr/share/tomcat',
  }
```

To create an instance with default settings:

```puppet
  class { '::tomcat': }

  tomcat::instance { 'mytomcat1' : }
```

To specify multiple instances with more specific settings (see
instance.pp for all parameters):


```puppet
  class { '::tomcat': }

  tomcat::instance { 'mytomcat1' : }
  tomcat::instance { 'mytomcat2' :
    ajp_port       => 8010,
    shutdown_port  => 8006,
    java_home      => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
  }
```

To override the tomcat class defaults (in this case we use an
alternative version of tomcat we have installed elsewhere for
mytomcat3, but use the base OS version of tomcat for mytomcat1 and
mytomcat2):


```puppet
  class { '::tomcat': }  

  tomcat::instance { 'mytomcat1' : }
  tomcat::instance { 'mytomcat2' :
    ajp_port       => 8010,
    shutdown_port  => 8006,
    java_home      => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
  }
  tomcat::instance { 'mytomcat3' :
    ajp_port       => 8011,
    shutdown_port  => 8007,
    parent_service => 'tomcat',
    tomcat_version => '7.0',
    catalina_home  => '/usr/share/tomcat',
    env_base       => '/etc/sysconfig',
    log_base       => '/var/log/tomcat',
    java_home      => '/usr/lib/jvm/jre-1.6.0-openjdk.x86_64',
  }
```

To have the tomcat class not install tomcat, but set some basic
defaults for creating instances (here we have ensured that tomcat 7.0
is already installed under /usr/share/tomcat, and create two tomcat 7.0
instances):


```puppet
  class { '::tomcat':
    package_ensure  => false,
    service_name   => 'tomcat',
    tomcat_version => '7.0',
    catalina_home  => '/usr/share/tomcat',
  }

  tomcat::instance { 'mytomcat1' : }
  tomcat::instance { 'mytomcat2' :
    ajp_port       => 8010,
    shutdown_port  => 8006,
  }
```
