module BlacklightMapsHelper
  include Blacklight::BlacklightMapsHelperBehavior
  include CommonwealthVlrEngine::BlacklightMapsHelper

  # LOCAL OVERRIDE: use a static file for catalog#map so page loads faster
  # render the map for #index and #map views
  def render_index_map
    puts "HEY BLOCKHEAD!"
    if Rails.env.to_s == 'production' && params[:action] == 'map' && File::exists?(GEOJSON_STATIC_FILE['filepath'])
      geojson_for_map = File.open(GEOJSON_STATIC_FILE['filepath']).first
    else
      geojson_for_map = serialize_geojson(map_facet_values)
    end
    render :partial => 'catalog/index_map',
           :locals => {:geojson_features => geojson_for_map}
  end

end
