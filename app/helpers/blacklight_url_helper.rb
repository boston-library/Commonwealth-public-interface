module BlacklightUrlHelper
  include Blacklight::UrlHelperBehavior

  # overriding to allow use in collections#show and institutions#show
  # so facet links in those views point to catalog#index
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

  # override to route to collections#show and institutions#show where appropriate
  def url_for_document doc, options = {}
    if respond_to?(:blacklight_config) && doc[blacklight_config.show.display_type_field]
      display_type = doc[blacklight_config.show.display_type_field]
      if display_type == 'Collection' || display_type == 'Institution'
        {controller: display_type.downcase.pluralize, action: :show, id: doc}
      else
        doc
      end
    else
      doc
    end
  end

end