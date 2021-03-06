#
# Cookbook Name:: guardian
# Recipe:: base
#
# Copyright (C) 2015, Rapid7, LLC.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt'
include_recipe "#{ cookbook_name }::nodejs"

node.default_unless['guardian']['version'] = cookbook_version

group node['guardian']['group'] do
  system true
end

user node['guardian']['user'] do
  system true
  home node['guardian']['home']
  group node['guardian']['group']
end

[node['guardian']['home'],
 node['guardian']['conf'],
 node['guardian']['path']].each do |d|
  next if resources(:directory => d) rescue false
  directory d do
    owner node['guardian']['user']
    group node['guardian']['group']
    mode '0755'
  end
end

template ::File.join(node['guardian']['conf'], 'site.json') do
  source 'json.erb'
  variables :content => node['guardian']['site']
end
