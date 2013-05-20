require 'spec_helper'

describe FolderItemsController do

  #having trouble with POST create should create a new folder item using ajax when views rendered
  #render_views

  before(:each) do
    @test_user_attr = {
        #:username => "Testy McGee",
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
          post :create, :id => "bpl-test:ff365549t", :folder_id => @folder.id
          response.should be_redirect
          @test_user.existing_folder_item_for("bpl-test:ff365549t").should_not be_false
        end.should change(FolderItem, :count).by(1)
      end

      it "should create a new folder item using ajax" do
        lambda do
          xhr :post, :create, :id => "bpl-test:ff365527s", :folder_id => @folder.id
          response.should be_success
          @test_user.existing_folder_item_for("bpl-test:ff365527s").should_not be_false
        end.should change(FolderItem, :count).by(1)
      end

    end

  end

  describe "DELETE destroy" do

    describe "success" do

      before(:each) do
        @folder.folder_items.create!(:document_id => "bpl-test:ff365531c")
      end

      it "should delete a folder item" do
        lambda do
          @request.env['HTTP_REFERER'] = '/folder_items'
          delete :destroy, :id => "bpl-test:ff365531c"
          response.should be_redirect
        end.should change(FolderItem, :count).by(-1)
      end

      it "should delete a folder item using ajax" do
        lambda do
          xhr :delete, :destroy, :id => "bpl-test:ff365531c"
          response.should be_success
        end.should change(FolderItem, :count).by(-1)
      end

    end

  end

  describe "DELETE clear" do

    describe "success" do

      before(:each) do
        @folder.folder_items.create!(:document_id => "bpl-test:ff365531c")
      end

      it "should clear the folder's folder items" do
        delete :clear, :id => @folder
        @folder.folder_items.count.should == 0
      end

    end

  end


end
