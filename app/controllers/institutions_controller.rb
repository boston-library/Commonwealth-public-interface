class InstitutionsController < CatalogController

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

  def institutions_filter(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Institution\""
  end

  def index
    self.solr_search_params_logic += [:institutions_filter]
    (@response, @document_list) = get_search_results
    params[:view] = 'list'
    params[:sort] = 'title_info_primary_ssort asc'
    params[:q] = 'nofocus' # dummy value to prevent autofocus of header search field

    respond_to do |format|
      format.html
    end
  end

  def show
    @show_response, @document = get_solr_response_for_doc_id
    @institution_title = @document[blacklight_config.index.show_link.to_sym]
    @collex_response, @collex_documents = get_search_results({:f => {'active_fedora_model_suffix_ssi'=> 'Collection','physical_location_ssim'=> @institution_title}},{:sort=> 'title_info_primary_ssort asc'})

    respond_to do |format|
      format.html
    end

  end

end