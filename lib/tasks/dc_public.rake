# rake tasks for Commonwealth-public-interface

namespace :dc_public do

  desc 'generate the static geojson file for catalog#map view'
  task :create_geojson => :environment do

    include BlacklightMapsHelper

    def blacklight_config
      CatalogController.blacklight_config
    end

    class BlacklightGeojsonTestClass < CatalogController
      include Blacklight::SearchHelper
    end

    @controller = BlacklightGeojsonTestClass.new
    @controller.request = ActionDispatch::TestRequest.new

    (@response, @document_list) = @controller.search_results({},@controller.search_params_logic)

    geojson_features = serialize_geojson(map_facet_values, 'index')
    if geojson_features
      File.open('./lib/assets/dc_static_geojson_catalog-map.json', 'w') {|f| f.write(geojson_features) }
      puts 'The GeoJSON file has successfully been created'
    else
      puts 'ERROR: The GeoJSON file was not created!'
    end

  end

end