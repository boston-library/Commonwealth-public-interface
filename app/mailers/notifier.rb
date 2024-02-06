# frozen_string_literal: true

class Notifier < ActionMailer::Base
  include CommonwealthVlrEngine::Notifier

  private

  # adds a few additional routing options
  def route_email(topic)
    return CONTACT_EMAILS['dc_admin'] if topic == t('blacklight.feedback.form.topic.options.membership.option')

    super
  end
end
