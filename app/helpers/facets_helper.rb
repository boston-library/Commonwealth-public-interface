module FacetsHelper
  include Blacklight::FacetsHelperBehavior
=begin
  # for display of series facets in collections#show
  def render_series_facet_value(facet_solr_field, item, options ={})
    series_title = facet_display_value(facet_solr_field, item)
    series_img = image_tag(datastream_disseminator_url(get_series_image_pid(series_title),'thumbnail300'),
                           :alt => series_title,
                           :class => 'index_thumb')
    link_to(series_img, add_facet_params_and_redirect(facet_solr_field, item))
    (link_to(series_title, add_facet_params_and_redirect(facet_solr_field, item), :class=>"facet_select") + " (" + render_facet_count(item.hits) + " items)").html_safe
  end
=end
end