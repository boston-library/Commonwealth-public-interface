# frozen_string_literal: true

require 'rails_helper'

describe PrimarySourceSetsHelper do
  let(:menu_item_data) { { 'thumbnail_id' => 'bpl-dev:abcd12345' } }
  let(:oai_menu_item_data) { { 'thumbnail_id' => 'bpl-oai:abcd12345' } }

  describe '#pss_thumbnail_url' do
    it 'return the correct thumbnail URL' do
      expect(helper.pss_thumbnail_url(menu_item_data)).to include(IIIF_SERVER['url'])
      expect(helper.pss_thumbnail_url(oai_menu_item_data)).to include("#{ASSET_STORE['url']}/derivatives")
    end
  end
end
