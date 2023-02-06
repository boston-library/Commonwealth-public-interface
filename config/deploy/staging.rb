# frozen_string_literal: true

# server-based syntax
# ======================
## STAGE_NAME is a paramter from Jenkins job: "staging", "qc", and "testing"
set :stage_case, ENV['STAGE_NAME']

## set :qc_server_ip, Rails.application.credentials.dig(:deploy,:qc,:server)
## set :staging_server_ip , Rails
# set :server_ip, Rails.application.credentials.dig(:deploy,"#{fetch(:stage_case)}".to_sym,  :server)
set :user, Rails.application.credentials.dig("deploy_#{fetch(:stage_case)}".to_sym, :user)
set :server_ip, Rails.application.credentials.dig("deploy_#{fetch(:stage_case)}".to_sym, :server)
set :ssh_key, Rails.application.credentials.dig("deploy_#{fetch(:stage_case)}".to_sym, :ssh_key)
# set :deploy_to, "/home/#{fetch(:user)}/railsApps/#{fetch(:application)}"

# set :branch, 'master'
set :branch, 'capistrano'

# role-based syntax
# ==================
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