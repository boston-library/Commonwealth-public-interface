class PagesController < ApplicationController

  def home
    @carousel_slides = CarouselSlide.where(:context=>'root').order(:sequence)
  end

  def about
    @nav_li_active = 'about'
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
