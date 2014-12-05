module BlacklightMapsHelper
  include Blacklight::BlacklightMapsHelperBehavior

  # create a link to a location name facet value
  def link_to_placename_facet field_value, field, displayvalue = nil
    new_params = params
    field_values = field_value.split(', ')
    if field_values.length > 1
      if field_values.last.length == 2
        state_name = Bplmodels::Constants::STATE_ABBR[field_values.last]
        field_values[field_values.length-1] = state_name if state_name
      end
    end
    field_values.each do |val|
      new_params = add_facet_params(field, val, new_params) unless params[:f] && params[:f][field] && params[:f][field].include?(val)
    end
    link_to(displayvalue.presence || field_value,
            catalog_index_path(new_params.except(:view, :id, :spatial_search_type, :coordinates)))
  end

end
