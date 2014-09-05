require 'spec_helper'

Capybara.javascript_driver = :webkit

describe 'openseadragon image viewer modal' do

  it 'should display the OSd viewer modal when the image is clicked', :js => true do
    visit solr_document_path(:id => 'bpl-dev:k930bx42b')
    click_link('img_viewer_link')
    expect(page).to have_selector('.openseadragon-container')
  end

end

describe 'multi image viewer' do

  before(:each) do
    visit solr_document_path(:id => 'bpl-dev:k930bx42b')
    click_link('carousel-nav_next')
  end

  it 'should display the next image when a prev-next link is clicked' do
    find('.img_show')['src'].should match /bpl-dev%3Ak930bx44w/
  end

  it 'should update the thumbnail in the #thumbnail_list' do
    all('#thumbnail_list li').last.should have_selector('.in_viewer')
  end

end