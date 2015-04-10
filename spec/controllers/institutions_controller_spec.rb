require 'spec_helper'

describe InstitutionsController do

  render_views

  describe "GET 'index'" do

    it "should show the institutions page" do
      get :index
      expect(response).to be_success
      expect(response.body).to have_selector("div.blacklight-institution")
      expect(assigns(:document_list)).not_to be_nil
    end

    it "should not show the grid view option" do
      get :index
      expect(response.body).to_not have_selector(".view-type-grid")
    end

    describe "map view" do

      it "should show the map on institutions page" do
        get :index, :view => 'maps'
        expect(response.body).to have_selector("#institutions-index-map")
      end

    end

  end

  describe "GET 'show'" do

    before(:each) do
      @institution_id = 'bpl-dev:4q77fr32b'
    end

    it "should show the institution page" do
      get :show, :id => @institution_id
      expect(response).to be_success
      expect(response.body).to have_selector("div.blacklight-institution")
      expect(assigns(:document)).not_to be_nil
    end

    it "should show some facets" do
      get :show, :id => @institution_id
      expect(response.body).to have_selector("#facets")
    end

    it "should show a list of collections" do
      get :show, :id => @institution_id
      expect(response.body).to have_selector("#institution_collections")
      expect(assigns(:document_list)).not_to be_nil
    end

  end

end