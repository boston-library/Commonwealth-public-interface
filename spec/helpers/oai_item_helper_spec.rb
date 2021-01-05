# frozen_string_literal: true

require 'rails_helper'

describe OaiItemHelper do
  let(:document) do
    { note_tsim: ['Information about this item was supplied by NOBLE Digital Heritage.'] }
  end

  describe '#oai_inst_name' do
    it 'returns special case for NOBLE' do
      expect(helper.oai_inst_name(document)).to eq('NOBLE Digital Heritage')
    end
  end
end
