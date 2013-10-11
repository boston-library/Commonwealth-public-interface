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
    @nav_li_active = 'institutions'
    self.solr_search_params_logic += [:institutions_filter]
    (@response, @document_list) = get_search_results
    params[:view] = 'list'
    params[:sort] = 'title_info_primary_ssort asc'

    respond_to do |format|
      format.html
    end
  end

  def show
    @nav_li_active = 'institutions'
    @show_response, @document = get_solr_response_for_doc_id
    @institution_title = @document[blacklight_config.index.show_link.to_sym]

    # get the response for collection objects
    @collex_response, @collex_documents = get_search_results({:f => {'active_fedora_model_suffix_ssi' => 'Collection','institution_pid_ssi' => params[:id]},:rows => 100},{:sort => 'title_info_primary_ssort asc'})

    # add params[:f] for proper facet links
    params[:f] = {'institution_name_ssim' => [@institution_title]}

    # get the response for the facets representing items in collection
    (@response, @document_list) = get_search_results({:f => {'institution_name_ssim' => @institution_title}})

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