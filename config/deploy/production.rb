# frozen_string_literal: true

# server-based syntax
# ======================

# stage_case means different deployment environment: staging, testing...
# If staging_case is set to "testing", capistrano deploys Commonwealth-public-interface to "testing" server.
# switch :stage_case to "staging" when deploying Commonwealth-public-interface to staging enviroment
# switch :stage_case to "qc" when deploying Commonwealth-public-interface to QC server
set :stage_case, 'qc'
# set :stage_case, 'staging'
# set :stage_case, 'testing'

## set :qc_server_ip, Rails.application.credentials.dig(:deploy,:qc,:server)
## set :staging_server_ip , Rails
# set :server_ip, Rails.application.credentials.dig(:deploy,"#{fetch(:stage_case)}".to_sym,  :server)
set :user, Rails.application.credentials.dig("deploy_#{fetch(:stage_case)}".to_sym, :user)
set :server_ip, Rails.application.credentials.dig("deploy_#{fetch(:stage_case)}".to_sym, :server)
set :ssh_key, Rails.application.credentials.dig("deploy_#{fetch(:stage_case)}".to_sym, :ssh_key)

# set :branch, 'master'
set :branch, 'capistrano'

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, ["#{fetch(:user)}@#{fetch(:server_ip)}"]
role :web, ["#{fetch(:user)}@#{fetch(:server_ip)}"]
role :db,  ["#{fetch(:user)}@#{fetch(:server_ip)}"]

## When Capistrano tries to delete old release, puma socket/id can be removed only by sudo user.
## Allow current user to run it with sudo priviledge.
SSHKit.config.command_map[:rm] = 'sudo rm'

# Custom SSH Options
# SSH to remote server uses username/password.
# For security reason, here uses ssh key.

server fetch(:server_ip).to_s, {
  :user => fetch(:user).to_s,
  :role => %w(app db web),
  :ssh_options => {
    :keys => fetch(:ssh_key).to_s
  }
}

