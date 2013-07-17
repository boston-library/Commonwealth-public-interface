require 'spec_helper'

describe Folder do

  before(:each) do
    @user_attr = {
        #:username => "Testy McGee",
        :email => "testy@example.com",
        :password => "password"
    }
    @user = User.create!(@user_attr)

    @folder_attr = { :title => "Test Folder Title", :description => "Test description."}
  end

  it "should create a new folder given valid attributes" do
    @user.folders.create!(@folder_attr)
  end

  describe "user associations" do

    before(:each) do
      @folder = @user.folders.create(@folder_attr)
    end

    it "should have a user attribute" do
      @folder.should respond_to(:user)
    end

    it "should have the right associated user" do
      @folder.user_id.should == @user.id
      @folder.user.should == @user
    end

  end

  describe "validations" do

    it "should require a user id" do
      Folder.new(@folder_attr).should_not be_valid
    end

    it "should require a title" do
      @user.folders.build(:title => "").should_not be_valid
    end

    it "should reject titles that are too long" do
      @user.folders.build(:title => "a" * 41).should_not be_valid
    end

    it "should reject descriptions that are too long" do
      @user.folders.build(:title => "Test Title", :description => "a" * 255).should_not be_valid
    end

  end

  describe "folder_items" do

    before(:each) do
      @folder = @user.folders.create!(@folder_attr)
      @folder_item = @folder.folder_items.create!(:document_id => "bpl-development:106")
    end

    it "should have a folder_items method" do
      @folder.should respond_to(:folder_items)
    end

    it "should include the item in the folder_items array" do
      @folder.folder_items.should include(@folder_item)
    end

  end




end
