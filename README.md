java
===========

My puppet module for Oracle Java JDK 7u79


This module has been built and tested using Puppet 3.7.5

Usage
===========

Rename the directory puppet-java to java

**Parameters**

####`user`

This parameter is used to set the owner and where java will be installed (home/`user`/opt).
**Default:** user

####`download`

This parameter is used to tell if you want to download from oracle and install or if you don't want to download.
If You don't want to download, you will need jdk-7u79-linux-x64.tar.gz and/or jdk-7u79-linux-i586.tar.gz in the java/files directory. It's better to have both, the module will check the system architecture before install.
**Default:** yes

**site.pp Example:** 

```puppet
class { 'java':
  user => 'your-user',
  download => 'no'
}
```

**or**

```puppet
class { 'java':
  user => 'your-user',
}
```

Remember: the default is 'yes' to download
