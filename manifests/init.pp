class java (
  $usuario = 'guihatano',
  $download = 'yes',
) {
	file { "/home/${usuario}/opt":
                ensure => 'directory',
                owner => $usuario,
                group => $usuario,
        }

	if ('64' in $::architecture) {
	    $so_arch = 'x64'
	}
	else {
	    $so_arch = 'i586'
        }
	if $download in ['no', 'nao', 'n', 'N', 'No', 'Nao' ] {
	    file { "/home/${usuario}/inst/jdk-7u71-linux-${so_arch}.tar.gz":
		ensure => present,
		owner => $usuario,
		group => $usuario,
		source => "puppet:///modules/java/jdk-7u71-linux-${so_arch}.tar.gz"
	    }
	    
	}
	else {
	    exec { 'jdk_wget':
		command => "/usr/bin/wget --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-${so_arch}.tar.gz -P /home/${usuario}/inst",
		creates => "/home/${usuario}/inst/jdk-7u71-linux-${so_arch}.tar.gz",
		user => $usuario,
		require => File["/home/${usuario}/opt"]
	    }
	}
	
	exec { 'jdk_extract':
		cwd => "/home/${usuario}/opt",
		command => "/bin/tar -xzf /home/${usuario}/inst/jdk-7u71-linux-${so_arch}.tar.gz",
		path => '/sbin:/bin:/usr/sbin:/usr/bin',
		unless => "ls /home/${usuario}/opt/jdk1.7.0_71",
		user => $usuario,
		require => File["/home/${usuario}/opt"] ;
		
		'jdk_link':
		cwd => "/home/${usuario}/opt",
		command => "/bin/ln -s jdk1.7.0_71/ jdk",
		unless => "/bin/ls /home/${usuario}/opt/jdk",
		user => $usuario,
		require => Exec['jdk_extract'] ;
		
		'jdk_env':
		cwd => "/home/${usuario}",
		command => "echo 'export JAVA_HOME=\$HOME/opt/jdk' >> .bashrc \
			&& /bin/echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >> .bashrc \
			&& su - ${usuario} -c 'source .bashrc'",
		path => '/sbin:/bin:/usr/sbin:/usr/bin',
		unless => 'cat .bashrc | grep JAVA_HOME',
		require => Exec['jdk_link'] ;
	}
}
