ec2_vpc { 'zeg-vpc':
  ensure       => present,
  region       => 'us-east-1',
  cidr_block   => '10.0.0.0/16',
}

ec2_securitygroup { 'zeg-sg':
  ensure      => present,
  region      => 'us-east-1',
  vpc         => 'zeg-vpc',
  description => 'Security group for VPC',
  ingress     => [{
    security_group => 'zeg-sg',
  },{
    protocol => 'tcp',
    port     => 22,
    cidr     => '0.0.0.0/0'
  },{
    protocol => 'tcp',
    port     => 8080,
    cidr     => '0.0.0.0/0'
  },{
    protocol => 'tcp',
    port     => 9090,
    cidr     => '0.0.0.0/0',
    description => 'prometeus'
  },{
    protocol => 'tcp',
    port     => 3000,
    cidr     => '0.0.0.0/0',
    description => 'Grafana'
  }]
}

ec2_vpc_subnet { 'zeg-subnet':
  ensure            => present,
  region            => 'us-east-1',
  vpc               => 'zeg-vpc',
  cidr_block        => '10.0.0.0/24',
  availability_zone => 'us-east-1a',
  route_table       => 'zeg-routes',
  map_public_ip_on_launch => true,
}

ec2_vpc_internet_gateway { 'zeg-igw':
  ensure => present,
  region => 'us-east-1',
  vpc    => 'zeg-vpc',
}

ec2_vpc_routetable { 'zeg-routes':
  ensure => present,
  region => 'us-east-1',
  vpc    => 'zeg-vpc',
  routes => [
    {
      destination_cidr_block => '10.0.0.0/16',
      gateway                => 'local'
    },{
      destination_cidr_block => '0.0.0.0/0',
      gateway                => 'zeg-igw'
    },
  ],

}

ec2_instance { 'zeg-node':
  ensure            => running,
  region            => 'us-east-1',
  availability_zone => 'us-east-1a',
  image_id          => 'ami-011b3ccf1bd6db744', # <-- us-east-1 RHEL7 Free Tier AMI 
  instance_type     => 't2.micro',
  key_name          => 'ZEG',
  subnet            => 'zeg-subnet',
  security_groups   => ['zeg-sg'],
#  block_devices       => [ {"delete_on_termination"=>"true", "device_name"=>"/dev/sdc", "volume_size"=>10, "encrypted"=>"No",},],
  tags              => {
    tag_name => 'value',
  },
  user_data       => template('/home/ec2-user/templates/inject.erb'),
}

