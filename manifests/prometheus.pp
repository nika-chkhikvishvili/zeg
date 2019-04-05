
class zeg::prometheus {

package { 'prometheus2':
ensure => 'installed',
provider => 'rpm',
source => 'https://packagecloud.io/prometheus-rpm/release/packages/el/7/prometheus2-2.8.1-1.el7.centos.x86_64.rpm/download.rpm',
}

package { 'alertmanager':
ensure => 'installed',
provider => 'rpm',
source => 'https://packagecloud.io/prometheus-rpm/release/packages/el/7/alertmanager-0.16.0-1.el7.centos.x86_64.rpm/download.rpm',
}






# configure prometeus
file { "/etc/prometheus/prometheus.yml":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/prometheus.yml',
    }   




# generate alerts with currenltly available crypto coins:
file { "/opt/generate_price_alert.sh":
        mode => "0755",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/generate_price_alert.sh',
    }



# start prometheus
service { "prometheus":
    provider => systemd,
    ensure => running,
    enable => true,
} 


# start alertmanager
service { "alertmanager":
    provider => systemd,
    ensure => running,
    enable => true,
}



# set Crypto Currency Dashboard to Home dashboard
exec { '/opt/generate_price_alert.sh >/dev/null':
  provider => shell,
  path    => ['/usr/bin', '/usr/sbin',],
}








}
