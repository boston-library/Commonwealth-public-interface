# use to render new image in multi image viewer in catalog#show
class ImageViewerController < CatalogController

  def show
    @response, @document = get_solr_response_for_doc_id
    #@img_to_show = params[:view]
    @title = @document[blacklight_config.index.show_link.to_sym]
    @page_sequence = get_page_sequence(@document.id, params[:view])
    respond_to do |format|
      format.js
      format.html { redirect_to catalog_path(@document.id,
                                             :view => params[:view]) }
    end
  end

  private

  def get_page_sequence(document_id, current_img_id)
    image_files = []
    Bplmodels::Finder.getImageFiles(document_id).each do |img_file|
      image_files << img_file['id']
    end
    create_img_sequence(image_files, current_img_id)
  end

end