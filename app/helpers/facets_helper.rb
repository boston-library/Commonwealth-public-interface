module FacetsHelper
  include Blacklight::FacetsHelperBehavior

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

    # Force controller#action to be catalog#index.
    new_params[:action] = "index"
    new_params[:controller] = "catalog"
    new_params
  end

  # for display of series facets in collections#show
  def render_series_facet_value(facet_solr_field, item, options ={})
    series_title = facet_display_value(facet_solr_field, item)
    series_img = image_tag(datastream_disseminator_url(get_series_image_pid(series_title),'thumbnail300'),
                           :alt => series_title,
                           :class => 'index_thumb')
    link_to(series_img, add_facet_params_and_redirect(facet_solr_field, item))
    (link_to(series_title, add_facet_params_and_redirect(facet_solr_field, item), :class=>"facet_select") + " (" + render_facet_count(item.hits) + " items)").html_safe
  end

end