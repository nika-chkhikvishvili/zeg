
# puppet ZEG module

This module spins ups aws ec2 instance with single manifest and does:

#### following magic:

1. [All below steps are provisioned, on a single server, by Puppet - configuration management system](#puppet)
2. [Running Linux server OS (e.g. CentOS 7)](#OS)
3. [Sets up Prometheus for data storage](#Prometheus)
4. [Setup Grafana as a front-end for Prometheus](#Grafana)
5. [Every XX minutes, scrapes and stores "Price" value for each item in the list of the first 10 items, on that web page https://www.cryptocompare.com](#Scraper)
6. [Each item has own panel/graph showing appropriate data in Grafana](#Dashboards)
7. [Fires alert if value changes for $10 (up or down) for the last 1h](Alert)

## puppet

### Requrements:

* puppet master.
* puppetlabs-aws module.

Follwoning information is required for ec2 instance provisioning:

1. AWS credentials:
```shell
$ cat /etc/puppetlabs/puppet/puppetlabs_aws_credentials.ini 

  [default]
  aws_access_key_id = <KEY-ID>
  aws_secret_access_key = <ACCESS-KEY>
  region = <REGION> #eg: us-east-1a
```
2. puppet master FQDN for cloud inject.
```shell
cat templates/inject.erb
PUPPET_MASTER='<FQDN>'
```
3. ssh key-pair name in aws 
```shell
cat manifests/deploy_aws_instance.pp
key_name          => '<KEY-NAME>',
```

[deploy_aws_instance.pp](https://github.com/nika-chkhikvishvili/zeg/blob/master/manifests/deploy_aws_instance.pp) creates VPC, Security Group, Subnet, Internet Gateway, Rout Table and EC2 Free Tries instance.

#### Usage:

1. Deplow Amazon AWS EC2 instance:
```shell
$ puppet apply manifests/deploy_aws_instance.pp  --noop
```
2. Wait while instance spins up...
3. Sign new node certificate:
```shell
$ puppetserver ca sign  --all
```
4. Wait while client pulls changes and done! or if you cant wait:
```shell
[client-host]$ puppet agent -t
```
5. navigate: new instance URL in browser: http://ec2-X-XX-XX-XX.compute-1.amazonaws.com:3000/ 

user: admin
pass: zgroup


## OS

Nothing special, prepeares OS for with basic configurations: installs neccesary packages.

### Prometheus

[prometheus.pp](https://github.com/nika-chkhikvishvili/zeg/blob/master/manifests/prometheus.pp) manifest does following:

* Installs and configures prometheus time series DB
* Installs and configures alertmanager
* Generates alerts based on first 10 cryptocoin information.

## Grafana

[grafana.pp](https://github.com/nika-chkhikvishvili/zeg/blob/master/manifests/grafana.pp) manifest does following:

* Installs and configures Grafana
* Installs dashboard
* Changes default password 
* Pins our dashboard to Home. 


## Scraper

[scraper.py](https://github.com/nika-chkhikvishvili/zeg/blob/master/files/scraper.py) Python script does following

* Acts as Embede HTTP server which listens on :8080
* Scrapes https://www.cryptocompare.com/
* Executes DOM by google-chrome and saves processed values in variable. "I was thinking using selenium/chromedriver approach, but what is the point?." - 42
* Uses bs4  to parse html.
* Reports back values in prometheus endpoint format: #HELP #TYPE, xxx
* Returs only gauges eg: btc 5059.62


## Dashboards:

Here is dashboards what looks like:
![grafana dshboard](https://raw.githubusercontent.com/nika-chkhikvishvili/zeg/master/files/grafana-dashboard.png)
![prometeus alert](https://raw.githubusercontent.com/nika-chkhikvishvili/zeg/master/files/prometeus-alert.png)


## Alerts
Fires Alert if Coin value changes for $10 (up or down) for the last 1h.

Alerts are created using PromQL queries: 

```regex
alert: btc:min5m
expr: (max_over_time(btc[1h]))
  - (min_over_time(btc[1h])) > 10
for: 10s
```

