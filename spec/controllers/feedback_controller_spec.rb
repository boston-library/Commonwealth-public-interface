require 'spec_helper'

describe FeedbackController do

  render_views

  describe "GET show" do

    it "should render the page" do
      get :show
      response.should be_success
    end

    it "should render the contact form" do
      get :show
      response.body.should have_selector("form[id='feedback_form']")
    end

  end

  describe "POST show" do

    describe "failure" do

      it "should display an error message for blank submission" do
        post :show
        response.body.should have_selector("div[id='error_explanation']")
        response.should_not redirect_to(feedback_complete_path)
      end

      it "should display an error message for invalid submission" do
        post :show, :name => '%^*)(', :email => 'thisnotvalid', :topic => 'whatever', :message => '%^*)('
        response.body.should have_selector("div[id='error_explanation']")
        response.should_not redirect_to(feedback_complete_path)
      end

    end

    describe "success" do

      it "should redirect to the complete path" do
        post :show, :name => 'Testy McGee', :email => 'test@test.edu', :topic => 'whatever', :message => 'Test message'
        response.should redirect_to(feedback_complete_path)
      end

      it "should create the email" do
        post :show, :name => 'Testy McGee', :email => 'test@test.edu', :topic => 'whatever', :message => 'Test message'
        ActionMailer::Base.deliveries.last.body.encoded.should have_text('Test message')
      end

    end

  end

end