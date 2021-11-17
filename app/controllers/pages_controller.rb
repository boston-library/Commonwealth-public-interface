# frozen_string_literal: true

class PagesController < ApplicationController
  include CommonwealthVlrEngine::Pages

  before_action :set_nav_about, only: [:about_dc, :copyright, :partners, :api, :content_statement]
  before_action :set_nav_educators, only: [:lesson_plans, :primary_sources, :searching_dc]

  def home
    @carousel_slides = CarouselSlide.where(context: 'root').order(:sequence)

    section_active_count = 0
    sections = ['maps', 'collections', 'institutions', 'formats']
    sections.each do |section|
      section_active_count += 1 if t("blacklight.home.browse.#{section}.enabled")
    end

    @middle_feature_columns = 12 / section_active_count
  end

  def about_dc
  end

  def lesson_plans
  end

  def primary_sources
  end

  def searching_dc
  end

  def copyright
  end

  def partners
  end

  def api
  end

  def privacy
  end

  def content_statement
  end

  # redirect for legacy DC links
  def collection_tree
    flash[:notice] = t('blacklight.update.new_url')
    redirect_to collections_path
  end

  # redirect for legacy DC links
  def contact
    flash[:notice] = t('blacklight.update.new_url')
    redirect_to feedback_path
  end

  # redirect for legacy DC links
  def items
    flash[:notice] = t('blacklight.update.item')
    redirect_to search_catalog_path
  end

  private

  def set_nav_about
    @nav_li_active = 'about'
  end

  def set_nav_educators
    @nav_li_active = 'for_educators'
  end
end
