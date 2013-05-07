require 'spec_helper'

describe CollectionsController do

  render_views

  describe "GET 'index'" do
    it "should show the collections page" do
      get :index
      response.should be_success
      response.body.should have_selector("div.blacklight-collection")
      assigns(:document_list).should_not be_nil
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @collection_id = 'bpl-test:rx913p89r'
    end

    it "should show the collection page" do
      get :show, :id => @collection_id
      response.should be_success
      response.body.should have_selector("div.blacklight-collection")
      assigns(:document).should_not be_nil
    end
  end

end
