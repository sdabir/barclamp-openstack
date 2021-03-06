# encoding: UTF-8
#
# Cookbook Name:: openstack-common
# Attributes:: default
#
# Copyright 2012-2013, AT&T Services, Inc.
# Copyright 2013, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Setting this to True means that database passwords and service user
# passwords for Keystone will be easy-to-remember values -- they will be
# the same value as the key. For instance, if a cookbook calls the
# ::Openstack::secret routine like so:
#
# pass = secret "passwords", "nova"
#
# The value of pass will be "nova"
default['openstack']['developer_mode'] = false

# The type of token signing to use (uuid or pki)
default['openstack']['auth']['strategy'] = 'uuid'

# Set to true where using self-signed certs (in testing environments)
default['openstack']['auth']['validate_certs'] = true

# ========================= Encrypted Databag Setup ===========================
#
# The openstack-common cookbook's default library contains a `secret`
# routine that looks up the value of encrypted databag values. This routine
# uses the secret key file located at the following location to decrypt the
# values in the data bag.
default['openstack']['secret']['key_path'] = '/etc/chef/openstack_data_bag_secret'

# The name of the encrypted data bag that stores service user passwords, with
# each key in the data bag corresponding to a named OpenStack service, like
# "nova", "cinder", etc.
default['openstack']['secret']['service_passwords_data_bag'] = 'service_passwords'

# The name of the encrypted data bag that stores DB passwords, with
# each key in the data bag corresponding to a named OpenStack database, like
# "nova", "cinder", etc.
default['openstack']['secret']['db_passwords_data_bag'] = 'db_passwords'

# The name of the encrypted data bag that stores Keystone user passwords, with
# each key in the data bag corresponding to a user (Keystone or otherwise).
default['openstack']['secret']['user_passwords_data_bag'] = 'user_passwords'

# ========================= Package and Repository Setup ======================
#
# Various Linux distributions provide OpenStack packages and repositories.
# The provide some sensible defaults, but feel free to override per your
# needs.

# The coordinated release of OpenStack codename
default['openstack']['release'] = 'havana'

# The Ubuntu Cloud Archive has packages for multiple Ubuntu releases. For
# more information, see: https://wiki.ubuntu.com/ServerTeam/CloudArchive.
# In the component strings, %codename% will be replaced by the value of
# the node['lsb']['codename'] Ohai value and %release% will be replaced
# by the value of node['openstack']['release']
default['openstack']['apt']['uri'] = 'http://ubuntu-cloud.archive.canonical.com/ubuntu'
default['openstack']['apt']['components'] = ["precise-updates/#{node['openstack']['release']}", 'main']
# For the SRU packaging, use this:
# default['openstack']['apt']['components'] = [ '%codename%-proposed/%release%', 'main' ]

default['openstack']['zypp']['repo-key'] = 'd85f9316'  # 32 bit key ID
default['openstack']['zypp']['uri'] = 'http://download.opensuse.org/repositories/Cloud:/OpenStack:/%release%/%suse-release%/'

default['openstack']['yum']['rdo_enabled'] = true
default['openstack']['yum']['uri'] = 'http://repos.fedorapeople.org/repos/openstack/openstack-havana/epel-6'
default['openstack']['yum']['repo-key'] = 'https://raw.github.com/redhat-openstack/rdo-release/master/RPM-GPG-KEY-RDO-Havana'

# ======================== OpenStack Endpoints ================================
#
# OpenStack recipes often need information about the various service
# endpoints in the deployment. For instance, the cookbook that deploys
# the Nova API service will need to set the glance_api_servers configuration
# option in the nova.conf, and the cookbook setting up the Glance image
# service might need information on the Swift proxy endpoint, etc. Having
# all of this related OpenStack endpoint information in a single set of
# common attributes in the openstack-common cookbook attributes means that
# instead of doing funky role-based lookups, a deployment zone's OpenStack
# endpoint information can simply be accessed by having the
# openstack-common::default recipe added to some base role definition file
# that all OpenStack nodes add to their run list.
#
# node['openstack']['endpoints'] is a hash of hashes, where each value hash
# contains one of more of the following keys:
#
#  - scheme
#  - uri
#  - host
#  - port
#  - path
#  - bind_interface
#
# If the uri key is set, its value is used as the full URI for the endpoint.
# If the uri key is not set, the endpoint's full URI is constructed from the
# component parts. This allows setups that use some standardized DNS names for
# OpenStack service endpoints in a deployment zone as well as setups that
# instead assign IP addresses (for an actual node or a load balanced virtual
# IP) in a network to a particular OpenStack service endpoint. If the
# bind_interface is set, it will set the host IP in the
# set_endpoints_by_interface recipe.

# ******************** OpenStack Identity Endpoints ***************************

# The OpenStack Identity (Keystone) bind endpoint.
default['openstack']['endpoints']['identity-bind']['host'] = '127.0.0.1'
default['openstack']['endpoints']['identity-bind']['scheme'] = nil
default['openstack']['endpoints']['identity-bind']['port'] = nil
default['openstack']['endpoints']['identity-bind']['path'] = nil
default['openstack']['endpoints']['identity-bind']['bind_interface'] = nil

# The OpenStack Identity (Keystone) API endpoint. This is commonly called
# the Keystone Service endpoint...
default['openstack']['endpoints']['identity-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['identity-api']['scheme'] = 'http'
default['openstack']['endpoints']['identity-api']['port'] = '5000'
default['openstack']['endpoints']['identity-api']['path'] = '/v2.0'
default['openstack']['endpoints']['identity-api']['bind_interface'] = nil

# The OpenStack Identity (Keystone) Admin API endpoint
default['openstack']['endpoints']['identity-admin']['host'] = '127.0.0.1'
default['openstack']['endpoints']['identity-admin']['scheme'] = 'http'
default['openstack']['endpoints']['identity-admin']['port'] = '35357'
default['openstack']['endpoints']['identity-admin']['path'] = '/v2.0'
default['openstack']['endpoints']['identity-admin']['bind_interface'] = nil

# ****************** OpenStack Compute Endpoints ******************************

# The OpenStack Compute (Nova) Native API endpoint
default['openstack']['endpoints']['compute-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['compute-api']['scheme'] = 'http'
default['openstack']['endpoints']['compute-api']['port'] = '8774'
default['openstack']['endpoints']['compute-api']['path'] = '/v2/%(tenant_id)s'
default['openstack']['endpoints']['compute-api']['bind_interface'] = nil

# The OpenStack Compute (Nova) EC2 API endpoint
default['openstack']['endpoints']['compute-ec2-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['compute-ec2-api']['scheme'] = 'http'
default['openstack']['endpoints']['compute-ec2-api']['port'] = '8773'
default['openstack']['endpoints']['compute-ec2-api']['path'] = '/services/Cloud'
default['openstack']['endpoints']['compute-ec2-api']['bind_interface'] = nil

# The OpenStack Compute (Nova) EC2 Admin API endpoint
default['openstack']['endpoints']['compute-ec2-admin']['host'] = '127.0.0.1'
default['openstack']['endpoints']['compute-ec2-admin']['scheme'] = 'http'
default['openstack']['endpoints']['compute-ec2-admin']['port'] = '8773'
default['openstack']['endpoints']['compute-ec2-admin']['path'] = '/services/Admin'
default['openstack']['endpoints']['compute-ec2-admin']['bind_interface'] = nil

# The OpenStack Compute (Nova) XVPvnc endpoint
default['openstack']['endpoints']['compute-xvpvnc']['host'] = '127.0.0.1'
default['openstack']['endpoints']['compute-xvpvnc']['scheme'] = 'http'
default['openstack']['endpoints']['compute-xvpvnc']['port'] = '6081'
default['openstack']['endpoints']['compute-xvpvnc']['path'] = '/console'
default['openstack']['endpoints']['compute-xvpvnc']['bind_interface'] = nil

# The OpenStack Compute (Nova) novnc endpoint
default['openstack']['endpoints']['compute-novnc']['host'] = '127.0.0.1'
default['openstack']['endpoints']['compute-novnc']['scheme'] = 'http'
default['openstack']['endpoints']['compute-novnc']['port'] = '6080'
default['openstack']['endpoints']['compute-novnc']['path'] = '/vnc_auto.html'
default['openstack']['endpoints']['compute-novnc']['bind_interface'] = nil

# ******************** OpenStack Network Endpoints ****************************

# The OpenStack Network (Neutron) API endpoint.
default['openstack']['endpoints']['network-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['network-api']['scheme'] = 'http'
default['openstack']['endpoints']['network-api']['port'] = '9696'
# neutronclient appends the protocol version to the endpoint URL, so the
# path needs to be empty
default['openstack']['endpoints']['network-api']['path'] = ''
default['openstack']['endpoints']['network-api']['bind_interface'] = nil

# ******************** OpenStack Image Endpoints ******************************

# The OpenStack Image (Glance) API endpoint
default['openstack']['endpoints']['image-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['image-api']['scheme'] = 'http'
default['openstack']['endpoints']['image-api']['port'] = '9292'
default['openstack']['endpoints']['image-api']['path'] = '/v2'
default['openstack']['endpoints']['image-api']['bind_interface'] = nil

# The OpenStack Image (Glance) Registry API endpoint
default['openstack']['endpoints']['image-registry']['host'] = '127.0.0.1'
default['openstack']['endpoints']['image-registry']['scheme'] = 'http'
default['openstack']['endpoints']['image-registry']['port'] = '9191'
default['openstack']['endpoints']['image-registry']['path'] = '/v2'
default['openstack']['endpoints']['image-registry']['bind_interface'] = nil

# ******************** OpenStack Volume Endpoints *****************************

# The OpenStack Volume (Cinder) API endpoint
default['openstack']['endpoints']['block-storage-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['block-storage-api']['scheme'] = 'http'
default['openstack']['endpoints']['block-storage-api']['port'] = '8776'
default['openstack']['endpoints']['block-storage-api']['path'] = '/v1/%(tenant_id)s'
default['openstack']['endpoints']['block-storage-api']['bind_interface'] = nil

# ******************** OpenStack Object Storage Endpoint *****************************

# The OpenStack Object Storage (Swift) API endpoint
default['openstack']['endpoints']['object-storage-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['object-storage-api']['scheme'] = 'http'
default['openstack']['endpoints']['object-storage-api']['port'] = '8080'
default['openstack']['endpoints']['object-storage-api']['path'] = '/v1/'
default['openstack']['endpoints']['object-storage-api']['bind_interface'] = nil

# ******************** OpenStack Metering Endpoints ***************************

# The OpenStack Metering (Ceilometer) API endpoint
default['openstack']['endpoints']['metering-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['metering-api']['scheme'] = 'http'
default['openstack']['endpoints']['metering-api']['port'] = '8777'
# The ceilometer client appends the protocol version to the endpoint URL,
# so the path needs to be empty
default['openstack']['endpoints']['metering-api']['path'] = ''
default['openstack']['endpoints']['metering-api']['bind_interface'] = nil

# ******************** OpenStack Orchestration Endpoints ***************************

# The OpenStack Orchestration (Heat) API endpoint
default['openstack']['endpoints']['orchestration-api']['host'] = '127.0.0.1'
default['openstack']['endpoints']['orchestration-api']['scheme'] = 'http'
default['openstack']['endpoints']['orchestration-api']['port'] = '8004'
default['openstack']['endpoints']['orchestration-api']['path'] = '/v1/%(tenant_id)s'
default['openstack']['endpoints']['orchestration-api']['bind_interface'] = nil

# The OpenStack Orchestration (Heat) CloudFormation API endpoint
default['openstack']['endpoints']['orchestration-api-cfn']['host'] = '127.0.0.1'
default['openstack']['endpoints']['orchestration-api-cfn']['scheme'] = 'http'
default['openstack']['endpoints']['orchestration-api-cfn']['port'] = '8000'
default['openstack']['endpoints']['orchestration-api-cfn']['path'] = '/v1'
default['openstack']['endpoints']['orchestration-api-cfn']['bind_interface'] = nil

# The OpenStack Orchestration (Heat) CloudWatch API endpoint
default['openstack']['endpoints']['orchestration-api-cloudwatch']['host'] = '127.0.0.1'
default['openstack']['endpoints']['orchestration-api-cloudwatch']['scheme'] = 'http'
default['openstack']['endpoints']['orchestration-api-cloudwatch']['port'] = '8003'
default['openstack']['endpoints']['orchestration-api-cloudwatch']['path'] = '/v1'
default['openstack']['endpoints']['orchestration-api-cloudwatch']['bind_interface'] = nil

# Alternately, if you used some standardized DNS naming scheme, you could
# do something like this, which would override any part-wise specifications above.
#
# default['openstack']['endpoints']['identity-api']['uri']         = 'https://identity.example.com:35357/v2.0'
# default['openstack']['endpoints']['identity-admin']['uri']       = 'https://identity.example.com:5000/v2.0'
# default['openstack']['endpoints']['compute-api']['uri']          = 'https://compute.example.com:8774/v2/%(tenant_id)s'
# default['openstack']['endpoints']['compute-ec2-api']['uri']      = 'https://ec2.example.com:8773/services/Cloud'
# default['openstack']['endpoints']['compute-ec2-admin']['uri']    = 'https://ec2.example.com:8773/services/Admin'
# default['openstack']['endpoints']['compute-xvpvnc']['uri']       = 'https://xvpvnc.example.com:6081/console'
# default['openstack']['endpoints']['compute-novnc']['uri']        = 'https://novnc.example.com:6080/vnc_auto.html'
# default['openstack']['endpoints']['image-api']['uri']            = 'https://image.example.com:9292/v2'
# default['openstack']['endpoints']['image-registry']['uri']       = 'https://image.example.com:9191/v2'
# default['openstack']['endpoints']['block-storage-api']['uri']           = 'https://volume.example.com:8776/v1/%(tenant_id)s'
# default['openstack']['endpoints']['metering-api']['uri']         = 'https://metering.example.com:9000/v1'
# default['openstack']['endpoints']['orchestration-api']['uri']               = 'https://orchestration.example.com:8004//v1/%(tenant_id)s'
# default['openstack']['endpoints']['orchestration-api-cfn']['uri']           = 'https://orchestration.example.com:8000/v1'
# default['openstack']['endpoints']['orchestration-api-cloudwatch']['uri']    = 'https://orchestration.example.com:8003/v1'

# logging.conf list keypairs module_name => log level to write
default['openstack']['logging']['ignore'] = { 'nova.api.openstack.wsgi' => 'WARNING',
                                              'nova.osapi_compute.wsgi.server' => 'WARNING' }

default['openstack']['memcached_servers'] = nil

# Default sysctl settings
default['openstack']['sysctl']['net.ipv4.conf.all.rp_filter'] = 0
default['openstack']['sysctl']['net.ipv4.conf.default.rp_filter'] = 0
