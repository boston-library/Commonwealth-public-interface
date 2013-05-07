module CollectionsHelper

  # overriding to allow use in collections/show
  # so facet links point to catalog/index
  def add_facet_params_and_redirect(field, item)
    new_params = add_facet_params(field, item)

    # Delete page, if needed.
    new_params.delete(:page)

    # Delete any request params from facet-specific action, needed
    # to redir to index action properly.
    Blacklight::Solr::FacetPaginator.request_keys.values.each do |paginator_key|
      new_params.delete(paginator_key)
    end
    new_params.delete(:id)

    # Force action to be index.
    new_params[:action] = "index"
    new_params[:controller] = "catalog"
    #new_params[:f] = {blacklight_config.collection_field => [@document[:label_ssim].first]}
    new_params
  end

end
