require 'spec_helper'

describe 'collections a-z links' do

  it 'should show the a-z links' do
    visit collections_path
    within ('#collection_az_links') do
      expect(page).to have_selector('.col_a-z_link')
    end
  end

  it 'should show correct results after clicking a letter link' do
    visit collections_path
    within ('#collection_az_links') do
      click_link('S')
    end
    expect(page).to have_selector('.item_index_title a', :text => 'Stephen Phillips Trust House Collection')
  end

end