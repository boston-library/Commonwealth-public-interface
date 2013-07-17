require 'spec_helper'

describe PagesController do

  render_views

  describe "GET 'home'" do
    it 'should show the home page' do
      get 'home'
      response.should be_success
      response.body.should have_selector('#content_home')
    end
  end

  describe "GET 'about'" do
    it 'should show the about page' do
      get 'about'
      response.should be_success
      response.body.should have_selector('#about_content')
    end
  end

end
