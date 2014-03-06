# use to render new image in multi image viewer in catalog#show
class ImageViewerController < ApplicationController

  def show
    @id = params[:id]
    @img_to_show = params[:view]
    respond_to do |format|
      format.js
      format.html { redirect_to catalog_path(@id,:view => @img_to_show) }
    end
  end

end