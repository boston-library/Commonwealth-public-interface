# frozen_string_literal: true

require 'rails_helper'

describe Notifier do
  describe 'feedback' do
    let(:email_params) do
      { name: 'Testy McGee', email: 'testy@example.com', topic: 'DC membership (library)',
        message: 'Test message' }
    end
    let(:test_feedback_email) { described_class.feedback(email_params) }

    it 'has the right receiver email address' do
      expect(test_feedback_email.to[0]).to eq(CONTACT_EMAILS['dc_admin'])
    end
  end
end
