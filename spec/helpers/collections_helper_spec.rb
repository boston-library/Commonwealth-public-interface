# frozen_string_literal: true

require 'rails_helper'

describe CollectionsHelper do
  describe '#should_render_col_az?' do
    it 'returns true' do
      expect(helper.should_render_col_az?).to be_truthy
    end
  end
end
