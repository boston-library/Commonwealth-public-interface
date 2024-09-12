# frozen_string_literal: true

module ApplicationHelper
  def render_survey_modal?
    cookies[:dc_survey_seen].nil?
  end
end
