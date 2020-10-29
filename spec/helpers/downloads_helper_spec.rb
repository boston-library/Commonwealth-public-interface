# frozen_string_literal: true

require 'rails_helper'

describe DownloadsHelper do
  let(:document) { { rightsstatement_ss: 'No Copyright - United States' } }

  describe '#public_domain?' do
    it 'returns true if doc has public domain rights statement' do
      expect(helper.public_domain?(document)).to be_truthy
    end

    it 'returns false in all other cases' do
      expect(helper.public_domain?({})).to be_falsey
    end
  end
end
