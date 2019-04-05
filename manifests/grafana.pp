
class zeg::grafana {

# create yum repo
file { "/etc/yum.repos.d/grafana.repo":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/grafana.repo',
    }


# install grafana-server
package { ['grafana'   ]:
ensure => installed,

}

# configure datasources
file { "/etc/grafana/provisioning/datasources/datasources.yaml":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/datasources.yaml',
    }   
# configure dashboards    
file { "/etc/grafana/provisioning/dashboards/dashboards.yaml":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/dashboards.yaml',
    } 

# configure Crypto Currency Dashboard
file { "/etc/grafana/provisioning/dashboards/crypto.json":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/zeg/crypto.json',
    }


# start grafana
service { "grafana-server":
    provider => systemd,
    ensure => running,
    enable => true,
} 


# change default password change annoying dialog
exec { 'sleep 5 && curl -s -X PUT -H "Content-Type: application/json" -d "{\"oldPassword\": \"admin\", \"newPassword\": \"zgroup\", \"confirmNew\": \"zgroup\"}" http://admin:admin@localhost:3000/api/user/password >/dev/null':
  provider => shell,
  path    => ['/usr/bin', '/usr/sbin',],
}

# set Crypto Currency Dashboard to Home dashboard
exec { 'sleep 3 && curl -s "http://admin:zgroup@localhost:3000/api/org/preferences" -H  "Content-Type: application/json" -H  "Accept: application/json" -X PUT -d "{\"theme\": \"\", \"homeDashboardId\":1,\"timezone\":\"\"}" >/dev/null':
  provider => shell,
  path    => ['/usr/bin', '/usr/sbin',],
}








}
