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
    (@response, @document_list) = get_search_results({:f => {'active_fedora_model_ssi'=> 'Bplmodels::Collection'},
                                                      :per_page => 20})
    params[:view] = 'list'

    respond_to do |format|
      format.html
    end
  end

  def show
    @show_response, @document = get_solr_response_for_doc_id
    @collection_title = @document[:label_ssim].first
    # add params[:f] for proper facet links
    params[:f] = {blacklight_config.collection_field => [@collection_title]}
    # get the response for the facets representing items in collection
    (@response, @document_list) = get_search_results({:f => {blacklight_config.collection_field => @collection_title}})

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


end
