# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InstitutionsHelper do

  let(:blacklight_config) { Blacklight::Configuration.new }

  before :each do
    CatalogController.blacklight_config = Blacklight::Configuration.new
    helper.stub(blacklight_config: blacklight_config)
  end

  describe "render_institutions_index" do

    context "with 'maps' document_index_view_type" do
      #subject { helper.render_institutions_index }
      #print page.html # debugging
      #it { should have_selector "div#institutions-index-map" }
      expect(helper.render_institutions_index).to include('HEY')
    end

  end

end
