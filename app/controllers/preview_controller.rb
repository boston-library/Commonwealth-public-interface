class PreviewController < ApplicationController

  def show
    @pid = params[:id]
    @image_url = get_thumb_url(@pid)
    #send_file get_thumb_url(@pid),
    #          :filename => 'thumbnail.jpg',
    #          :type => :jpg,
    #          :disposition => 'inline'
    redirect_to @image_url
  end

  private

  def get_thumb_url(pid)
    thumb_url = 'http://www.bpl.org/wp-content/uploads/2012/12/sports_thumb.jpg'
    return thumb_url
  end

end
