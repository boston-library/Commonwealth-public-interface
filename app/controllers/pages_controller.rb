class PagesController < ApplicationController

  def home
    @carousel_slides = CarouselSlide.where(:context=>'root').order(:sequence)
  end

  def about
  end

end
