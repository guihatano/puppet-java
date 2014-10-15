java
===========

My puppet module for Oracle Java JDK


This module has been built and tested using Puppet 3.7.1

Usage
===========

Rename the directory puppet-java to java

**Parameters**

####`usuario`

This parameter is used to set the owner and where java will be installed (home/`usuario`/opt).
Default: guihatano (sorry xD, I will change in the future)

####`download`

This parameter is used to tell if you want to download from oracle and install or if you don't want to download.
If You don't want to download, you will need to have jdk-7u67-linux-x64.tar.gz and/or jdk-7u67-linux-i586.tar.gz in the java/files directory. It's better to have both, the module will check the system architecture before install.
Default: no

**site.pp Example:** 

```puppet
class = { 'java'
  usuario => 'your-user',
  download => 'yes'
}
```
