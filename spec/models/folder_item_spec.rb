require 'spec_helper'

describe FolderItem do

  before(:each) do
    @test_user_attr = {
        :username => "Testy McGee",
        :email => "testy@example.com",
        :password => "password"
    }
    @test_user = User.create!(@test_user_attr)
    @folder = @test_user.folders.create!(:title => "Test Folder Title")
    @folder_item = @folder.folder_items.build(:document_id => "bpl-development:107")
  end

  it "should create a new folder_item given valid attributes" do
    @folder_item.save!
  end

  describe "methods" do

    before(:each) do
      @folder_item.save!
    end

    it "should have a folder attribute" do
      @folder_item.should respond_to(:folder)
    end

    it "should have a document attribute" do
      @folder_item.should respond_to(:document)
    end

  end


end
