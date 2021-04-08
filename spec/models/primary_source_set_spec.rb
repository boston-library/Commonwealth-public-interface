# frozen_string_literal: true

require 'rails_helper'

describe PrimarySourceSet do
  subject { described_class.new('index') }

  it 'has a title' do
    expect(subject.title).to_not be_blank
  end

  it 'has intro text' do
    expect(subject.intro_text).to_not be_blank
  end

  it 'has menu_items' do
    expect(subject.menu_items).to_not be_blank
  end

  it 'returns subjects' do
    expect(subject.subjects).to eq []
  end

  it 'returns parent' do
    expect(subject.parent).to eq nil
  end

  it 'returns item_documents' do
    expect(subject.item_documents).to eq []
  end

  it 'returns collection_documents' do
    expect(subject.collection_documents).to eq []
  end
end
