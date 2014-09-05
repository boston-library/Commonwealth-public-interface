require 'spec_helper'

describe ImageViewerController do

  render_views

  describe "GET 'show'" do
    it 'should render the partial using ajax with the new image' do
      xhr :get, :show, :id => 'bpl-dev:k930bx42b', :view => 'bpl-dev:k930bx44w'
      response.should be_success
      # not great, but OK for now
      response.body.should match /fedora%2Fobjects%2Fbpl-dev%3Ak930bx44w%2Fdatastreams%2FaccessMaster/
    end
  end

  describe 'get #book_viewer' do
    it 'should render the book viewer' do
      get :book_viewer, :id => 'bpl-dev:k930bx42b'
      response.should be_success
      response.body.should have_selector('#viewer')
    end
  end

end