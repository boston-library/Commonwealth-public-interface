require 'spec_helper'

describe FolderItemsController do

  render_views

  before(:each) do
    @test_user_attr = {
        :username => "Testy McGee",
        :email => "testy@example.com",
        :password => "password"
    }
    @test_user = User.create!(@test_user_attr)
    sign_in @test_user
    @test_folder_attr = {:title => "Test Folder Title"}
    @folder = @test_user.folders.create!(@test_folder_attr)
  end


  describe "POST create" do

    describe "success" do

      it "should create a new folder item" do
        lambda do
          @request.env['HTTP_REFERER'] = '/folder_items/new'
          post :create, :folder_items => [{ :document_id => "bpl-development:102", :folder_id => @folder.id }]
          response.should be_redirect
          @test_user.existing_folder_item_for("bpl-development:102").should_not be_false
        end.should change(FolderItem, :count).by(1)
      end

      it "should create a new folder item using ajax" do
        lambda do
          xhr :post, :create, :folder_items => [{ :document_id => "bpl-development:103", :folder_id => @folder.id }]
          response.should be_success
          @test_user.existing_folder_item_for("bpl-development:103").should_not be_false
        end.should change(FolderItem, :count).by(1)
      end

    end

  end

  describe "DELETE destroy" do

    describe "success" do

      before(:each) do
        @folder.folder_items.create!(:document_id => "bpl-development:101")
      end

      it "should delete a folder item" do
        lambda do
          @request.env['HTTP_REFERER'] = '/folder_items'
          delete :destroy, :id => "bpl-development:101"
          response.should be_redirect
        end.should change(FolderItem, :count).by(-1)
      end

      it "should delete a folder item using ajax" do
        lambda do
          xhr :delete, :destroy, :id => "bpl-development:101"
          response.should be_success
        end.should change(FolderItem, :count).by(-1)
      end

    end

  end

  describe "DELETE clear" do

    describe "success" do

      before(:each) do
        @folder.folder_items.create!(:document_id => "bpl-development:101")
      end

      it "should clear the folder's folder items" do
        delete :clear, :id => @folder
        @folder.folder_items.count.should == 0
      end

    end

  end

  describe "DELETE delete_selected" do

    before(:each) do
      @folder.folder_items.create!(:document_id => "bpl-development:100")
      @folder.folder_items.create!(:document_id => "bpl-development:99")
      @folder.folder_items.create!(:document_id => "bpl-development:98")
    end

    describe "success" do

      it "should remove the selected items" do
        lambda do
          delete :delete_selected, :id => @folder, :selected => ["bpl-development:100", "bpl-development:99"]
          response.should be_redirect
        end.should change(@folder.folder_items, :count).by(-2)
      end

    end


  end

end
