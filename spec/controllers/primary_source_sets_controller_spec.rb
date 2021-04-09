# frozen_string_literal: true

require 'rails_helper'

describe PrimarySourceSetsController do
  render_views

  describe 'index' do
    it 'renders the index page' do
      get :index
      expect(response).to be_successful
      expect(response.body).to have_selector('#primary_source_set_menu')
    end
  end

  describe 'show' do
    it 'renders the show page' do
      get :show, params: { id: 'global_connections' }
      expect(response).to be_successful
      expect(response.body).to have_selector('#documents_wrapper')
    end
  end
end
