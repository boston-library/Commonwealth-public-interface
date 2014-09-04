require 'spec_helper'

describe 'openseadragon image viewer modal' do

  Capybara.javascript_driver = :webkit

  it 'should display the OSd viewer modal when the image is clicked', :js => true do
    visit solr_document_path(:id => 'bpl-dev:k930bx42b')
    click_link('img_viewer_link')
    expect(page).to have_selector('.openseadragon-container')
  end

end