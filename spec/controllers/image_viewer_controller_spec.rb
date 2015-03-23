require 'spec_helper'

describe ImageViewerController do

  render_views

  describe "GET 'show'" do
    it 'should render the partial using ajax with the new image' do
      xhr :get, :show, :id => 'bpl-dev:h702q6403', :view => 'bpl-dev:h702q642n'
      response.should be_success
      # not great, but OK for now
      response.body.should match /bpl-dev:h702q642n/
    end
  end

  describe 'get #book_viewer' do
    it 'should render the book viewer' do
      get :book_viewer, :id => 'bpl-dev:h702q6403'
      response.should be_success
      response.body.should have_selector('#viewer')
    end
  end

end