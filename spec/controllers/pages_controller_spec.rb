require 'rails_helper'

describe PagesController do

  render_views

  describe "GET 'home'" do
    it 'should show the home page' do
      get :home
      expect(response).to be_successful
      expect(response.body).to have_selector('#content_home')
    end
  end

  describe "GET 'about'" do
    it 'should show the about page' do
      get :about
      expect(response).to be_successful
      expect(response.body).to have_selector('ul.page_list')
    end
  end

  describe "GET 'about_dc'" do
    it 'should show the about_dc page' do
      get :about_dc
      expect(response).to be_successful
      expect(response.body).to have_selector('div.about_content')
    end
  end

  describe "GET 'lesson_plans'" do
    it 'should show the lesson_plans page' do
      get :lesson_plans
      expect(response).to be_successful
      expect(response.body).to have_selector('#lesson_plan_list')
    end
  end

  describe "GET 'copyright'" do
    it 'should show the copyright page' do
      get :copyright
      expect(response).to be_successful
      expect(response.body).to have_selector('div.about_content')
    end
  end

  describe "GET 'partners'" do
    it 'should show the partners page' do
      get :partners
      expect(response).to be_successful
      expect(response.body).to have_selector('#partner_list')
    end
  end

  describe "GET 'api'" do
    it 'should show the API page' do
      get :api
      expect(response).to be_successful
      expect(response.body).to have_selector('div.about_content')
    end
  end

end
