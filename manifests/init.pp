class java (
  $user = 'user',
  $download = 'yes',
) {
	file { "/home/${user}/opt":
                ensure => 'directory',
                owner => $user,
                group => $user,
        }

	if ('64' in $::architecture) {
	    $so_arch = 'x64'
	}
	else {
	    $so_arch = 'i586'
        }
	if $download in ['no', 'nao', 'n', 'N', 'No', 'Nao' ] {
	    file { "/home/${user}/inst/jdk-7u79-linux-${so_arch}.tar.gz":
		ensure => present,
		owner => $user,
		group => $user,
		source => "puppet:///modules/java/jdk-7u79-linux-${so_arch}.tar.gz"
	    }
	    
	}
	else {
	    exec { 'jdk_wget':
		command => "/usr/bin/wget --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/7u79-b14/jdk-7u79-linux-${so_arch}.tar.gz -P /home/${user}/inst",
		creates => "/home/${user}/inst/jdk-7u79-linux-${so_arch}.tar.gz",
		user => $user,
		require => File["/home/${user}/opt"]
	    }
	}
	
	exec { 'jdk_extract':
		cwd => "/home/${user}/opt",
		command => "/bin/tar -xzf /home/${user}/inst/jdk-7u79-linux-${so_arch}.tar.gz",
		path => '/sbin:/bin:/usr/sbin:/usr/bin',
		unless => "ls /home/${user}/opt/jdk1.7.0_79",
		user => $user,
		require => File["/home/${user}/opt"] ;
		
		'jdk_link':
		cwd => "/home/${user}/opt",
		command => "/bin/ln -s jdk1.7.0_79/ jdk",
		unless => "/bin/ls /home/${user}/opt/jdk",
		user => $user,
		require => Exec['jdk_extract'] ;
		
		'jdk_env':
		cwd => "/home/${user}",
		command => "echo 'export JAVA_HOME=\$HOME/opt/jdk' >> .bashrc \
			&& /bin/echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >> .bashrc \
			&& su - ${user} -c 'source .bashrc'",
		path => '/sbin:/bin:/usr/sbin:/usr/bin',
		unless => 'cat .bashrc | grep JAVA_HOME',
		require => Exec['jdk_link'] ;
	}
}
