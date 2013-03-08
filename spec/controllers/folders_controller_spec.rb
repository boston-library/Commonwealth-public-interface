require 'spec_helper'

describe FoldersController do

  render_views

  before(:each) do
    @test_user_attr = {
        :username => "Testy McGee",
        :email => "testy@example.com",
        :password => "password"
    }
    @test_user = User.create!(@test_user_attr)
  end

  describe "GET index" do

    describe "non-logged in user" do

      it "should link to the bookmarks folder" do
        get :index
        response.body.should have_selector("a[href='/bookmarks']")
      end

      it "should not show any folders" do
        get :index
        @folders.should be_nil
      end

    end

    describe "logged-in user" do

      before(:each) do
        sign_in @test_user
      end

      describe "user has no folders yet" do

        it "should not show any folders" do
          get :index
          @test_user.folders.should be_empty
          @folders.should be_nil
        end

      end

      describe "user has folders" do

        before(:each) do
          @test_folder_attr = {:title => "Test Folder Title"}
          @test_user.folders.create!(@test_folder_attr)
        end

        it "should show the user's folders" do
          get :index
          response.body.should have_selector("ul[id='user_folder_list']")
        end

      end

    end

  end

  describe "DELETE destroy" do

    before(:each) do
      @test_folder_attr = {:title => "Test Folder Title"}
      @test_user.folders.create!(@test_folder_attr)
    end

    describe "non-logged in user" do

      #it "should redirect to the login page" do
      #delete :destroy, :id => @test_user.folders.first.id
      # TODO: neither of the below work due to ?referer=%2Ffolders suffix on end of URL. not sure how to test for this.
      #response.should redirect_to(new_user_session_path)
      #response.should redirect_to(:controller => 'devise/sessions', :action => 'new' )
      #end

    end

    describe "logged-in user" do

      before(:each) do
        sign_in @test_user
      end

      it "should delete the folder" do
        lambda do
          delete :destroy, :id => @test_user.folders.first.id
        end.should change(Folder, :count).by(-1)
      end

      it "should redirect to the folders page" do
        delete :destroy, :id => @test_user.folders.first.id
        response.should redirect_to(:controller => 'folders', :action => 'index')
      end

    end

  end

  describe "GET new" do

    before(:each) do
      sign_in @test_user
    end

    it "should return http success" do
      get :new
      response.should be_success
    end

    it "should display the form" do
      get :new
      response.body.should have_selector("form[id='new_folder']")
    end

  end

  describe "GET show" do

    before(:each) do
      @test_folder_attr = {:title => "Test Folder Title"}
      @folder = @test_user.folders.create!(@test_folder_attr)
    end

    describe "non-logged in user" do

      #it "should redirect to the login page" do
      #delete :destroy, :id => @test_user.folders.first.id
      # TODO: neither of the below work due to ?referer=%2Ffolders suffix on end of URL. not sure how to test for this.
      #response.should redirect_to(new_user_session_path)
      #response.should redirect_to(:controller => 'devise/sessions', :action => 'new' )
      #end

    end

    describe "logged-in user" do

      before(:each) do
        sign_in @test_user
      end

      it "should show the folder title" do
        get :show, :id => @folder.id
        response.body.should have_selector("h2", :text => @folder.title)
      end

      describe "user has folder with items" do

        before(:each) do
          @test_folder_item = @folder.folder_items.create!(:document_id => "bpl-development:107")
        end

        it "should show a link to the folder item" do
          get :show, :id => @folder.id
          response.body.should have_selector("a[href='/catalog/" + @test_folder_item.document_id + "']")
        end

      end

    end

    describe "wrong user" do

      before(:each) do
        sign_in @test_user
        @test_folder_attr = {:title => "Test Folder Title"}
        @folder = @test_user.folders.create!(@test_folder_attr)
        sign_out @test_user
        @other_user_attr = {
            :username => "Testy McOther",
            :email => "testy@other.com",
            :password => "password"
        }
        @other_user = User.create!(@other_user_attr)
        sign_in @other_user
      end

      it "should not allow access to another user's folder" do
        get :show, :id => @folder.id
        response.should redirect_to(root_path)
      end

    end

  end

  describe "POST create" do

    describe "non-logged-in user" do

      #it "should deny access to create" do
      #post :create
      # TODO: below doesn't work due to ?referer=%2Ffolders suffix on end of URL.
      # not sure how to test for this.
      #response.should redirect_to(:controller => 'devise/sessions', :action => 'new' )
      #end

    end

    describe "logged-in user" do

      before(:each) do
        sign_in @test_user
      end

      describe "failure" do

        it "should not create a folder" do
          lambda do
            post :create, :folder => {:title => ""}
          end.should_not change(Folder, :count)
        end

        it "should re-render the create page" do
          post :create, :folder => {:title => ""}
          response.should render_template('folders/new')
        end

      end

      describe "success" do

        it "should create a folder" do
          lambda do
            post :create, :folder => {:title => "Whatever, man"}
          end.should change(Folder, :count).by(1)
        end

        it "should redirect to the folders page" do
          post :create, :folder => {:title => "Whatever, man"}
          response.should redirect_to(:controller => 'folders', :action => 'index')
        end

      end


    end

  end

  describe "GET edit" do

    before(:each) do
      @test_folder_attr = {:title => "Test Folder Title"}
      @folder = @test_user.folders.create!(@test_folder_attr)
    end

    describe "non-logged-in user" do

      #it "should deny access to edit" do
      #get :edit, :id => @folder.id
      # TODO: below doesn't work due to ?referer=%2Ffolders suffix on end of URL. not sure how to test for this.
      #response.should redirect_to(:controller => 'devise/sessions', :action => 'new' )
      #end

    end

    describe "logged-in user" do

      before(:each) do
        sign_in @test_user
      end

      it "should show the edit form with the correct title value" do
        get :edit, :id => @folder.id
        response.body.should have_field("folder_title", :with => @folder.title)
      end

    end

  end

  describe "PUT update" do

    before(:each) do
      @test_folder_attr = {:title => "Test Folder Title"}
      @folder = @test_user.folders.create!(@test_folder_attr)
    end

    describe "non-logged-in user" do

      #it "should deny access to create" do
      #put :update, :id => @folder.id
      # TODO: below doesn't work due to ?referer=%2Ffolders suffix on end of URL. not sure how to test for this.
      #response.should redirect_to(:controller => 'devise/sessions', :action => 'new' )
      #end

    end

    describe "logged-in user" do

      before(:each) do
        sign_in @test_user
      end

      describe "failure" do

        it "should not update the folder" do
          put :update, :id => @folder.id, :folder => {:title => ""}
          @folder.reload
          @folder.title.should_not == ""
        end

        it "should re-render the edit form" do
          put :update, :id => @folder.id, :folder => {:title => ""}
          response.should render_template('folders/edit')
        end

      end

      describe "success" do

        it "should update the folder" do
          put :update, :id => @folder.id, :folder => {:title => "New Folder Title"}
          @folder.reload
          @folder.title.should == "New Folder Title"
        end

        it "should redirect to the folders show page" do
          put :update, :id => @folder.id, :folder => {:title => "New Folder Title"}
          response.should redirect_to(:controller => 'folders', :action => 'show')
        end

      end

    end

  end

end
