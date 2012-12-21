class FolderItem < ActiveRecord::Base
  attr_accessible :document_id

  belongs_to :folder
  #belongs_to :document

  validates :folder_id, :presence => true
  validates :document_id, :presence => true

  def document
    SolrDocument.new SolrDocument.unique_key => :document_id
  end

end
