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

end
