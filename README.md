
# puppet ZEG module

This module spins ups aws ec2 instance with single manifest and does:

#### following magic:

1. [All below steps are provisioned, on a single server, by Puppet - configuration management system](#puppet)
2. [Running Linux server OS (e.g. CentOS 7)](os)
3. [Sets up Prometheus for data storage](#prometheus)
4. [Setup Grafana as a front-end for Prometheus](grafana)
5. [Every XX minutes, scrapes and stores "Price" value for each item in the list of the first 10 items, on that web page https://www.cryptocompare.com](#scrape)
6. [Each item has own panel/graph showing appropriate data in Grafana](#dashboard)
7. [Fires alert if value changes for $10 (up or down) for the last 1h](alert)

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

[deploy_aws_instance.pp](https://github.com/nika-chkhikvishvili/zeg/manifests/deploy_aws_instance.pp) creates VPC, Security Group, Subnet, Internet Gateway, Rout Table and EC2 Free Tries instance.

#### Usage:

1. Deplow Amazon AWS EC2 instance:
```shell
$ puppet apply deploy_aws_instance.pp  --noop
```
2. Wait while instance spins up...
3. Sign new node certificate:
```shell
$ puppetserver ca sign  --all
```

## Setup

### What module affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For example, folks can probably figure out that your mysql_instance module affects their MySQL instances.

If there's more that they should know about, though, this is the place to mention:

* Files, packages, services, or operations that the module will alter, impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, another module, etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps for upgrading, you might want to include an additional "Upgrading" section here.

### Beginning with module

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your users how to use your module to solve problems, and be sure to include code examples. Include three to five examples of the most important or common tasks a user can accomplish with your module. Show users how to accomplish more complex tasks that involve different types, classes, and functions working in tandem.

## Reference

This section is deprecated. Instead, add reference information to your code as Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your module. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

If you aren't ready to use Strings yet, manually create a REFERENCE.md in the root of your module directory and list out each of your module's classes, defined types, facts, functions, Puppet tasks, task plans, and resource types and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
