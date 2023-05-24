# frozen_string_literal: true

namespace :users do
  desc 'Reset passwords for facebook users and clear uid field'
  task reset_facebook: :environment do
    puts 'Preparing to send password reset instructions to facebook users'
    users = User.where(provider: 'facebook')
    users_count = users.count
    failed = []
    if users.present?
      puts "Reseting passwords for #{users_count} users"
      users.find_each do |u|
        begin
          u.send_reset_password_instructions
          sleep(10)
          u.uid = nil
          u.save!
        rescue => e
          next failed << { user_id: u.id, error_msg: e.message }
        end
      end

      if failed.present?
        failed_user_json_file_path = Rails.root.join('tmp', 'facebook_user_failures.json').to_s
        puts 'Some users could not be updated.'
        puts "Number of faulres #{failed.count}"
        puts "Writing output to json file to #{failed_user_json_file_path}"
        File.open(failed_user_json_file_path, 'w+') { |f| f.write(JSON.pretty_generate(failed)) }
      else
        puts "Successfully updated #{users_count} Users"
      end
    else
      puts 'No Facebook users found.'
    end
    puts 'End Task'
  end

  desc 'Clear provider field for facebook users'
  task clear_facebook: :environment do
    puts 'Preparing to clear provider = facebook for users'
    users = User.where(provider: 'facebook')

    if users.present?
      puts "Found #{users.count} Users"
      users.update_all(provider: nil)
      puts 'Successfully cleared provider filed for users with provider = facebook'
    else
      puts 'No Users with provider = facebook found'
    end

    puts 'End Task'
  end

  desc 'Clear guest users rake task'
  task clear_guest_users: :environment do
    puts 'Preparing to clear guest users older than 90 days'
    users = User.where(guest: true).where('updated_at <= ?', 90.days.ago)
    if users.present?
      puts "Found #{users.count} Users"
      folder_items = Bpluser::FolderItem.joins(:folder).where(bpluser_folders: { user_id: users.pluck(:id) })
      if folder_items.present?
        puts "Deleting #{folder_items.count} folder items..."
        folder_items.destroy_all
        puts 'Deleted Folders successfully'
      end

      folders = Bpluser::Folder.where(user_id: users.pluck(:id))
      if folders.present?
        puts "Deleting #{folders.count} folders..."
        folders.destroy_all
        puts 'Deleted folders successfully'
      end
      users.reload.destroy_all
      puts 'Deleted users successfully'
    else
      puts 'No guest users older than 90 days found!'
    end
    puts 'End Task'
  end
end
