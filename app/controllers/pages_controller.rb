class PagesController < ApplicationController
  include CommonwealthVlrEngine::Pages

  def home
    @carousel_slides = CarouselSlide.where(:context=>'root').order(:sequence)

    section_active_count = 0
    sections = ['maps', 'collections', 'institutions', 'formats']
    sections.each do |section|
      if t("blacklight.home.browse.#{section}.enabled")
        section_active_count += 1
      end
    end

    @middle_feature_columns = 12 /  section_active_count
  end

  def about_dc
    @nav_li_active = 'about'
  end

  def lesson_plans
    @nav_li_active = 'for_educators'
  end

  def copyright
    @nav_li_active = 'about'
  end

  def partners
    @nav_li_active = 'about'
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
    redirect_to catalog_index_path
  end

end