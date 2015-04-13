class InstitutionsController < CatalogController

  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)

  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url options = {}
    catalog_index_url(options.except(:controller, :action))
  end
  helper_method :search_action_url

  def institutions_filter(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Institution\""
  end

  def index
    @nav_li_active = 'explore'
    self.solr_search_params_logic += [:institutions_filter]
    params[:per_page] = params[:per_page].presence || '50'
    (@response, @document_list) = get_search_results
    params[:view] ||= 'list' # still need this or grid view is invoked
    params[:sort] = 'title_info_primary_ssort asc'

    respond_to do |format|
      format.html
    end
  end

  def show
    @nav_li_active = 'explore'
    @show_response, @document = get_solr_response_for_doc_id(params[:id])
    @institution_title = @document[blacklight_config.index.title_field.to_sym]

    # get the response for collection objects
    @collex_response, @collex_documents = get_search_results({:f => {'active_fedora_model_suffix_ssi' => 'Collection','institution_pid_ssi' => params[:id]},:rows => 100},{:sort => 'title_info_primary_ssort asc'})

    # add params[:f] for proper facet links
    params[:f] = {blacklight_config.institution_field => [@institution_title]}

    # get the response for the facets representing items in collection
    (@response, @document_list) = get_search_results({:f => params[:f]})

    respond_to do |format|
      format.html
    end

  end

  # remove grid view from blacklight_config for index view
  def remove_grid_view
    blacklight_config.view.delete(:grid)
  end

  before_filter :remove_grid_view, :only => [:index]

end