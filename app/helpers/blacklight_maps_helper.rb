module BlacklightMapsHelper
  include Blacklight::BlacklightMapsHelperBehavior

  # LOCAL OVERRIDE: convert state abbreviations, deal with complex locations, etc.
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

  # LOCAL OVERRIDE: use a static file for catalog#map so page loads faster
  # render the map for #index and #map views
  def render_index_map
    if Rails.env.to_s == 'production' && params[:action] == 'map' && File::exists?(GEOJSON_STATIC_FILE['filepath'])
      geojson_for_map = File.open(GEOJSON_STATIC_FILE['filepath']).first
    else
      geojson_for_map = serialize_geojson(map_facet_values)
    end
    render :partial => 'catalog/index_map',
           :locals => {:geojson_features => geojson_for_map}
  end

  # LOCAL OVERRIDE: allow controller.action name to be passed, allow @controller
  # pass the document or facet values to BlacklightMaps::GeojsonExport
  def serialize_geojson(documents, action_name=nil)
    action = action_name || controller.action_name
    cntrllr = @controller || controller
    export = BlacklightMaps::GeojsonExport.new(cntrllr, action, documents)
    export.to_geojson
  end

end
