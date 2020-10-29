# frozen_string_literal: true

require 'rails_helper'

describe InstitutionsHelper do
  describe '#should_render_inst_az?' do
    it 'returns true' do
      expect(helper.should_render_inst_az?).to be_truthy
    end
  end
end
