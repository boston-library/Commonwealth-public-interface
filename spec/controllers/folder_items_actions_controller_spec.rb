require 'spec_helper'

describe FolderItemsActionsController do

  render_views

  before(:each) do
    @test_user_attr = {
        #:username => "Testy McGee",
        :email => "testy@example.com",
        :password => "password"
    }
    @test_user = User.create!(@test_user_attr)
    sign_in @test_user
    @test_folder_attr = {:title => "Test Folder Title",:visibility => 'private'}
    @folder = @test_user.folders.create!(@test_folder_attr)
    @folder.folder_items.create!(:document_id => "bpl-development:100")
    @folder.folder_items.create!(:document_id => "bpl-development:99")
    @folder.folder_items.create!(:document_id => "bpl-development:98")
  end

  describe "folder_item_actions: remove" do

    describe "success" do

      it "should remove the selected items" do
        expect {
          put :folder_item_actions,
              :commit => "Remove",
              :origin => "folders",
              :id => @folder,
              :selected => ["bpl-development:100", "bpl-development:99"]
          expect(response).to be_redirect
        }.to change(@folder.folder_items, :count).by(-2)
      end

    end

  end

  describe "folder_item_actions: copy" do

    before(:each) do
      @test_folder2_attr = {:title => "Other Test Folder Title",:visibility => 'private'}
      @folder2 = @test_user.folders.create!(@test_folder2_attr)
    end

    describe "success" do

      it "should copy the selected items to folder2" do
        expect {
          @request.env['HTTP_REFERER'] = '/folders/' + @folder.id.to_s
          put :folder_item_actions,
              :commit => "Copy to " + @folder2.id.to_s,
              :origin => "folders",
              :id => @folder,
              :selected => ["bpl-development:100", "bpl-development:99"]
          expect(response).to be_redirect
        }.to change(@folder2.folder_items, :count).by(2)
      end

    end

  end

  describe "folder_item_actions: cite" do

    describe "success" do

      it "should redirect to the cite url" do
        put :folder_item_actions,
              :commit => "Cite",
              :origin => "folders",
              :id => @folder,
              :selected => ["bpl-development:99"]
          expect(response).to redirect_to(citation_catalog_path(:id => ["bpl-development:99"]))
      end

    end

  end

  describe "folder_item_actions: email" do

    describe "success" do

      it "should redirect to the email url" do
        put :folder_item_actions,
            :commit => "Email",
            :origin => "folders",
            :id => @folder,
            :selected => ["bpl-development:99"]
        expect(response).to redirect_to(email_catalog_path(:id => ["bpl-development:99"]))
      end

    end

  end

end