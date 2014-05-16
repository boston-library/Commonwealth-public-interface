class InstitutionsController < CatalogController

  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)


  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url *args
    catalog_index_url *args
  end
  helper_method :search_action_url

  def institutions_filter(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Institution\""
    solr_parameters[:rows] = 50
  end

  def index
    @nav_li_active = 'explore'
    self.solr_search_params_logic += [:institutions_filter]
    (@response, @document_list) = get_search_results
    params[:view] = 'list'
    params[:sort] = 'title_info_primary_ssort asc'

    respond_to do |format|
      format.html
    end
  end

  def show
    @nav_li_active = 'explore'
    @show_response, @document = get_solr_response_for_doc_id
    @institution_title = @document[blacklight_config.index.title_field.to_sym]

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

  #maybe don't need this anymore?
=begin
  # copied from Blacklight::Catalog
  # displays values and pagination links for a single facet field
  def facet
    @facet = blacklight_config.facet_fields[params[:id]]
    @response = get_facet_field_response(@facet.field, params)
    @display_facet = @response.facets.first

    # @pagination was deprecated in Blacklight 5.1
    @pagination = facet_paginator(@facet, @display_facet)


    respond_to do |format|
      # Draw the facet selector for users who have javascript disabled:
      format.html
      format.json { render json: render_facet_list_as_json }

      # Draw the partial for the "more" facet modal window:
      format.js { render :layout => false }
    end
  end
=end
end