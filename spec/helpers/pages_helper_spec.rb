# frozen_string_literal: true

require 'rails_helper'

describe PagesHelper do
  describe '#render_about_site_path' do
    it 'returns the about_dc path' do
      expect(helper.render_about_site_path).to eq('/about_dc')
    end
  end
end
