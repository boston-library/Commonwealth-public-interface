class Notifier < ActionMailer::Base
  include CommonwealthVlrEngine::Notifier

  private

  # adds a few additional routing options
  def route_email(topic)
    recipient_email = if topic == t('blacklight.feedback.form.topic.options.membership.option')
                        CONTACT_EMAILS['dc_admin']
                      elsif topic == t('blacklight.feedback.form.topic.options.research.option')
                        CONTACT_EMAILS['research_question']
                      else
                        nil
                      end
    recipient_email || super
  end
end
