require 'spec_helper'

describe InstitutionsController do

  render_views

  describe "GET 'index'" do

    it "should show the institutions page" do
      get :index
      response.should be_success
      response.body.should have_selector("div.blacklight-institution")
      assigns(:document_list).should_not be_nil
    end

    it "should not show the grid view option" do
      get :index
      response.body.should_not have_selector(".view-type-grid")
    end

    describe "map view" do

      it "should show the map on institutions page" do
        get :index, :view => 'maps'
        response.body.should have_selector("#institutions-index-map")
      end

    end

  end

  describe "GET 'show'" do

    before(:each) do
      @institution_id = 'bpl-dev:4q77fr32b'
    end

    it "should show the institution page" do
      get :show, :id => @institution_id
      response.should be_success
      response.body.should have_selector("div.blacklight-institution")
      assigns(:document).should_not be_nil
    end

    it "should show some facets" do
      get :show, :id => @institution_id
      response.body.should have_selector("#facets")
    end

    it "should show a list of collections" do
      get :show, :id => @institution_id
      response.body.should have_selector("#institution_collections")
      assigns(:document_list).should_not be_nil
    end

  end

end