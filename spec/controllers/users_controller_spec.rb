require 'spec_helper'

describe UsersController do

  render_views

  before(:each) do
    @test_user_attr = {
        #:username => "Testy McGee",
        :email => 'testy@example.com',
        :password => 'password'
    }
    @test_user = User.create!(@test_user_attr)
  end

  describe 'Get show' do

    describe 'non-logged-in user' do
      it 'should redirect to the sign-in page' do
        get :show, :id => @test_user.id
        response.should redirect_to(new_user_session_path)
      end
    end

    describe 'logged-in user' do

      describe 'trying to view wrong account' do

        before(:each) do
          sign_in @test_user
          @test_user2_attr = {
              #:username => "Testy McGee",
              :email => 'testy2@example.com',
              :password => 'password'
          }
          @test_user2 = User.create!(@test_user2_attr)
        end

        it 'should redirect to the home page' do
          get :show, :id => @test_user2.id
          response.should redirect_to(root_path)
        end


      end

      describe 'viewing correct account' do

        before(:each) do
          sign_in @test_user
        end

        it 'should show the user#show page' do
          get :show, :id => @test_user.id
          response.should be_success
          response.body.should have_selector('#user_account_links_list')
        end

      end

    end

  end

end