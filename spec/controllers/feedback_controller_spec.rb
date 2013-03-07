require 'spec_helper'

describe FeedbackController do

  render_views

  describe "GET show" do

    it "should render the page" do
      get 'show'
      response.should be_success
    end

  end

end