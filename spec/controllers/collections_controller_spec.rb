require 'spec_helper'

describe CollectionsController do

  render_views

  include BlacklightMapsHelper

  def blacklight_config
    CatalogController.blacklight_config
  end

  describe "GET 'index'" do
    it "should show the collections page" do
      get :index
      expect(response).to be_success
      expect(response.body).to have_selector("div.blacklight-collection")
      expect(assigns(:document_list)).not_to be_nil
    end
  end

  describe "GET 'show'" do

    before(:each) do
      get :show, :id => 'bpl-dev:h702q636h'
    end

    it "should show the collection page" do
      expect(response).to be_success
      expect(response.body).to have_selector("div.blacklight-collection")
      expect(assigns(:document)).not_to be_nil
    end

    it "should show some facets" do
      expect(response.body).to have_selector("#facets")
    end

    it "should show the collection image and title" do
      expect(response.body).to have_selector(".collection_img_show")
      expect(response.body).to have_selector("#collection_img_caption")
    end

    it "should show the series list" do
      expect(response.body).to have_selector("#facet-related_item_series_ssim")
      expect(assigns(:document_list)).not_to be_nil
    end

    it "should show the map" do
      expect(response.body).to have_selector("#blacklight-collection-map-container")
      expect(assigns(:response).facet_by_field_name(map_facet_field).items).not_to be_empty
    end

  end

  describe "private methods" do

    # for testing private methods
    class CollectionsControllerTestClass < CollectionsController
      attr_accessor :params
    end

    before(:each) do
      @mock_controller = CollectionsControllerTestClass.new
      @mock_controller.params = {}
      @mock_controller.request = ActionDispatch::TestRequest.new
      @collection_pid = 'bpl-dev:h702q636h'
      @collection_image_pid = 'bpl-dev:h702q642n'
    end

    describe "get_collection_image_info" do

      it "should return a hash with the collection image object title and pid" do
        expect(@mock_controller.send(:get_collection_image_info,@collection_image_pid,@collection_pid)).to eq({title:'Beauregard', pid:'bpl-dev:h702q6403', access_master:true})
      end

    end

    describe "get_series_image_obj" do

      it "should return the series object" do
        expect(@mock_controller.send(:get_series_image_obj,'Test Series','Carte de Visite Collection')[:exemplary_image_ssi]).to eq('bpl-dev:h702q641c')
      end

    end

  end




end
