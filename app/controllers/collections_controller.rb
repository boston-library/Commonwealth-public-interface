class CollectionsController < CatalogController

  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)

  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url
    catalog_index_url
  end
  helper_method :search_action_url

  def index
    (@response, @document_list) = get_search_results({:f => {'active_fedora_model_suffix_ssi'=> 'Collection'},
                                                      :per_page => 20})
    params[:view] = 'list'
    params[:sort] = 'title_info_primary_ssort asc'

    respond_to do |format|
      format.html
    end
  end

  def show
    @show_response, @document = get_solr_response_for_doc_id
    @collection_title = @document[blacklight_config.index.show_link.to_sym]

    # add params[:f] for proper facet links
    params[:f] = {blacklight_config.collection_field => [@collection_title]}

    # get the response for the facets representing items in collection
    (@response, @document_list) = get_search_results({:f => {blacklight_config.collection_field => @collection_title}})

    # get an image for the collection
    if @document[:has_image_ssim]
      @collection_image_pid = @document[:has_image_ssim].first.to_s.gsub(/info:fedora\//,'')
    else
      @collection_image_pid = collection_image(@document)
    end

    respond_to do |format|
      format.html
    end

  end

  # copied from Blacklight::Catalog
  # displays values and pagination links for a single facet field
  def facet
    @pagination = get_facet_pagination(params[:id], params)

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  private

  # use the first member object of the collection as the collection image
  def collection_image(document)
    coll_image_object = document[:has_collection_member_ssim].first.gsub(/info:fedora\//,"")
    @coll_image_response, @coll_image_document = get_solr_response_for_doc_id(coll_image_object)
    if @coll_image_document[:has_image_ssim]
      return @coll_image_document[:has_image_ssim].first.gsub(/info:fedora\//,"")
    end

  end



end