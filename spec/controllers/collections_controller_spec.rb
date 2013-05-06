require 'spec_helper'

describe CollectionsController do

  render_views

  describe "GET 'index'" do
    it "should show the collections page" do
      get :index
      response.should be_success
      response.body.should have_selector("div.blacklight-collection")
      # figure out why below don't work.
      @document_list.should_not be_nil
    end
  end

end
