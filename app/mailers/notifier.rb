class Notifier < ActionMailer::Base

  include CommonwealthVlrEngine::Notifier

  private

  def route_email(topic)
    if topic == t('blacklight.feedback.form.topic.options.membership')
      recipient_email = CONTACT_EMAILS['dc_admin']
    elsif topic == t('blacklight.feedback.form.topic.options.repro')
      recipient_email = CONTACT_EMAILS['image_requests']
    else
      recipient_email = CONTACT_EMAILS['site_admin']
    end
    recipient_email
  end

end
