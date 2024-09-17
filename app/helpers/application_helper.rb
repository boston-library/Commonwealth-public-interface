# frozen_string_literal: true

module ApplicationHelper
  def survey_cookie_name
    "_#{I18n.t('blacklight.application_name').delete(' ')}_survey_seen"
  end

  def render_survey_modal?
    cookies[survey_cookie_name].nil?
  end
end
