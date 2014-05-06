module BlacklightUrlHelper
  include Blacklight::UrlHelperBehavior

  # overriding to allow use in collections/show
  # so facet links point to catalog/index
  def add_facet_params_and_redirect(field, item)
    new_params = add_facet_params(field, item)

    # Delete any request params from facet-specific action, needed
    # to redir to index action properly.
    new_params.except! *Blacklight::Solr::FacetPaginator.request_keys.values

    # Force controller#action to be catalog#index.
    new_params[:action] = "index"
    new_params[:controller] = "catalog"
    new_params
  end

end