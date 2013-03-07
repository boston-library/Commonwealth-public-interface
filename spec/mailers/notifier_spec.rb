require "spec_helper"

describe Notifier do

  describe "feedback" do

    before(:each) do
      @test_params = {
          :name => "Testy McGee",
          :email => "testy@example.com",
          :message => "Test message"
      }
      @test_feedback_email = Notifier.feedback(@test_params)
    end

    it "should create the email" do
      @test_feedback_email.should_not be_nil
    end

    it "should have the right user email in the text" do
      @test_feedback_email.body.encoded.should have_text(@test_params[:email])
    end

    it "should have the right receiver email address" do
      @test_feedback_email.to.should == [I18n.t('blacklight.repo-admin.email')]
    end

  end

end
