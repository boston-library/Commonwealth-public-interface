module BlacklightMapsHelper
  include Blacklight::BlacklightMapsHelperBehavior

  # create a link to a location name facet value
  def link_to_placename_field field_value, field, displayvalue = nil
    new_params = params
    field_values = field_value.split(', ')
    if field_values.last.match(/[\.\)]/) # Mass.)
      field_values = [field_values.join(', ')]
    end
    if field_values.length > 2
      new_field_values = []
      new_field_values[0] = field_value.split(/[,][ \w]*\z/).first
      new_field_values[1] = field_values.last
      field_values = new_field_values
    end
    if field_values.length == 2 && field_values.last.length == 2
      state_name = Bplmodels::Constants::STATE_ABBR[field_values.last]
      field_values[field_values.length-1] = state_name if state_name
    end
    field_values.each do |val|
      place = val.match(/\(county\)/) ? val : val.gsub(/\s\([a-z]*\)\z/,'')
      new_params = add_facet_params(field, place, new_params) unless params[:f] && params[:f][field] && params[:f][field].include?(place)
    end
    link_to(displayvalue.presence || field_value,
            catalog_index_path(new_params.except(:view, :id, :spatial_search_type, :coordinates)))
  end

end
