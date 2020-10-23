# -*- encoding : utf-8 -*-
# commenting out as this is throwing errors
# 'attachments' may be reserved word in Rails 4 maybe?
class CreateBatchUploads < ActiveRecord::Migration

  def self.up
    #create_table :batch_uploads do |t|
    #  t.attachment :upload
    #  t.timestamps
    #end
  end

  def self.down
    #drop_table :batch_uploads
  end
  
end
