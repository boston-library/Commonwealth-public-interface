class CollectionsController < CatalogController

  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)

  # show series facet for collections#show
  configure_blacklight do |config|
    series_facet = config.facet_fields["related_item_series_ssim"]
    series_facet.show = true
    series_facet.if = true # have to include this or it won't display!
    series_facet.limit = 300
    series_facet.sort = 'index'
    series_facet.include_in_request = true
  end

  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url *args
    catalog_index_url *args
  end
  helper_method :search_action_url

  def collections_filter(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Collection\""
  end

  def index
    @nav_li_active = 'explore'
    self.solr_search_params_logic += [:collections_filter]
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
    @collection_title = @document[blacklight_config.index.title_field.to_sym]

    # add params[:f] for proper facet links
    params[:f] = {blacklight_config.collection_field => [@collection_title],
                  blacklight_config.institution_field => @document[blacklight_config.institution_field.to_sym]}

    # get the response for the facets representing items in collection
    (@response, @document_list) = get_search_results({:f => params[:f]})

    # get an image for the collection
    if @document[:exemplary_image_ssi]
      @collection_image_pid = @document[:exemplary_image_ssi]
      @collection_image_info = get_collection_image_info(@collection_image_pid)
    end

    respond_to do |format|
      format.html
    end

  end

  private

  # find the title and pid for the object representing the collection image
  def get_collection_image_info(image_pid)
    (col_img_response, col_img_doc_list) = get_search_results(
        {:f => {'exemplary_image_ssi' => image_pid,
                'has_model_ssim' => 'info:fedora/afmodel:Bplmodels_ObjectBase'}})
    if col_img_doc_list.length > 0
      col_img_info = {
          :title => col_img_doc_list.first[blacklight_config.index.title_field.to_sym],
          :pid => col_img_doc_list.first[:id]
      }
    end
  end

  # find a representative image for a series
  # TODO better exception handling for items which don't have exemplary_image
  def get_series_image_obj(series_title,collection_title)
    (@series_response, @series_doc_list) = get_search_results(
        {:f => {'related_item_series_ssim' => series_title,
                blacklight_config.collection_field => collection_title},
         :rows => 1
        })
    @series_doc_list.first
  end
  helper_method :get_series_image_obj

  # Not using this for now
  # find a representative image for a collection if none is assigned
  # TODO better exception handling for items which don't have exemplary_image
  #def get_collection_image_pid(collection_title)
  #  (@default_coll_img_resp, @default_coll_img_doc_list) = get_search_results(
  #      {:f => {blacklight_config.collection_field => collection_title,
  #              'has_model_ssim' => 'info:fedora/afmodel:Bplmodels_ObjectBase'},
  #       :rows => 1
  #      })
  #  @default_coll_img_doc_list.first[:exemplary_image_ssi]
  #end
  #helper_method :get_collection_image_pid

end
