# frozen_string_literal: true

require 'rails_helper'

describe CatalogHelper do
  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:collection_pid) { 'bpl-dev:h702q636h' }
  let(:institution_pid) { 'bpl-dev:abcd12345' }
  let(:document) do
    { institution_name_ssim: ['Boston Public Library'],
      institution_pid_ssi: institution_pid,
      collection_name_ssim: ['Carte de Visite Collection'],
      collection_pid_ssm: [collection_pid] }
  end

  before(:each) do
    allow(helper).to receive_messages(blacklight_config: blacklight_config)
  end

  describe '#render_item_breadcrumb' do
    it 'renders the institution and collection links' do
      expect(helper.render_item_breadcrumb(document)).to include('href="/collections/' + collection_pid)
      expect(helper.render_item_breadcrumb(document)).to include('href="/institutions/' + institution_pid)
    end
  end
end
