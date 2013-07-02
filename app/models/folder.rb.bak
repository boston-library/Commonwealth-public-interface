class Folder < ActiveRecord::Base

  belongs_to :user
  has_many :folder_items, :dependent => :destroy

  validates :user_id, :presence => true
  validates :title, :presence => true, :length => {:maximum => 40}
  validates :description, :length => {:maximum => 250}

  attr_accessible :id, :title, :description
end
