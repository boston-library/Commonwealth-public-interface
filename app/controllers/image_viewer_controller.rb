# use to render new image in multi image viewer in catalog#show
class ImageViewerController < CatalogController

  def show
    @response, @document = get_solr_response_for_doc_id
    #@id = params[:id]
    @img_to_show = params[:view]
    @title = @document[blacklight_config.index.show_link.to_sym]
    respond_to do |format|
      format.js
      format.html { redirect_to catalog_path(@document.id,:view => @img_to_show) }
    end
  end

end