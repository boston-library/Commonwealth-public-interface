class Notifier < ActionMailer::Base
  #default from: 'hal3000@repository.digitalcommonwealth.org'

  def feedback(details)

    @message = details[:message]
    @email = details[:email]
    @name = details[:name]

    mail(:to => t('blacklight.repo-admin.email'),
         :from => t('blacklight.email.record_mailer.name') + ' <' + t('blacklight.email.record_mailer.email') + '>',
         :subject => t('blacklight.feedback.text.subject'))

  end

end
