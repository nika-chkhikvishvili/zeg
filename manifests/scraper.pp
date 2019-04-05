
class zeg::scraper {



# create yum repo
file { "/etc/yum.repos.d/google.repo":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/google.repo',
    }






package { 'epel-release':
ensure => 'installed',
provider => 'rpm',
source => 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
}

package { ['python-html5lib'   ]:
ensure => installed,
}

package { 'python-beautifulsoup4':
ensure => 'installed',
provider => 'rpm',
source => 'http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/python-beautifulsoup4-4.3.2-1.el7.noarch.rpm',
}

package { 'liberation-fonts':
ensure => 'installed',
provider => 'rpm',
source => 'http://mirror.centos.org/centos/7/os/x86_64/Packages/liberation-fonts-1.07.2-16.el7.noarch.rpm',
}



package { 'google-chrome-stable':
ensure => 'installed',
}





# clone scraper.py
file { "/opt/scraper.py":
        mode => "0755",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/scraper.py',
    }



# daemonize scraper.py
file { "/etc/systemd/system/scraper.service":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/scraper.service',
    }   

# start scraper
service { "scraper":
    provider => systemd,
    ensure => running,
    enable => true,
} 





}
