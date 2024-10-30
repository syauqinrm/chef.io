#
# Cookbook:: user_management
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# Create user 'bajautest' with UID 2022
user 'bajautest' do
  uid 2022
  comment 'User bajautest'
  home '/home/bajautest'
  shell '/bin/bash'
  manage_home true
end

# Create user 'testchef' with UID 2010
user 'testchef' do
  uid 2010
  comment 'User testchef'
  home '/home/testchef'
  shell '/bin/bash'
  manage_home true
end

# Create user 'masterchef' with UID 2030
user 'masterchef' do
  uid 2030
  comment 'User masterchef'
  home '/home/masterchef'
  shell '/bin/bash'
  manage_home true
end

# Create user 'masterchef' with UID 2030
user 'testing' do
  uid 2030
  comment 'User masterchef'
  home '/home/masterchef'
  shell '/bin/bash'
  manage_home true
end

