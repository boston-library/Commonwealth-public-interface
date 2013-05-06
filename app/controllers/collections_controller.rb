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
      format.html { save_current_search_params }
    end
  end

  def show
    @response, @document = get_solr_response_for_doc_id

    respond_to do |format|
      format.html {setup_next_and_previous_documents}

    end

  end

end
