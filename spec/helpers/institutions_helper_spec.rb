# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InstitutionsHelper do

  let(:blacklight_config) { Blacklight::Configuration.new }
=begin
  def create_response
    raw_response = eval(mock_query_response)
    Blacklight::SolrResponse.new(raw_response, raw_response['params'])
  end

  let(:r) { create_response }
=end
  before :each do
    CatalogController.blacklight_config = Blacklight::Configuration.new
    helper.stub(blacklight_config: blacklight_config)
    @request = ActionDispatch::TestRequest.new
    @catalog = CatalogController.new
    @catalog.request = @request
    @catalog.action_name = "index"
    helper.instance_variable_set(:@_controller, @catalog)
    #@docs = r.facet_by_field_name(blacklight_config.view.maps.geojson_field).items
    @geojson_hash = {type:"Feature", geometry:{type:"Point",coordinates:[91.117212, 29.646923]},properties:{placename:"Tibet"}}
    @coords = [91.117212,29.646923]
    @bbox = [78.3955448,26.8548157,99.116241,36.4833345]
    puts "THE HELPER = " + helper.render_institutions_index
  end

  describe "render_institutions_index" do

    context "with 'maps' document_index_view_type" do
      #allow(helper).to receive_messages(document_index_view_type: :maps)
      subject { helper.render_institutions_index }

      it { should have_selector "div#documents" }
      #expect(helper.render_institutions_index).to include('HEY')
    end

  end

  def mock_query_response
    %({"responseHeader"=>{"status"=>0, "QTime"=>14, "params"=>{"q"=>"tibet", "spellcheck.q"=>"tibet", "qt"=>"search", "wt"=>"ruby", "rows"=>"10"}}, "response"=>{"numFound"=>2, "start"=>0, "maxScore"=>0.016135123, "docs"=>[{"published_display"=>["Dharamsala, H.P."], "author_display"=>"Thub-bstan-yar-ÃŠÂ¼phel, Rnam-grwa", "lc_callnum_display"=>["DS785 .T475 2005"], "pub_date"=>["2005"], "format"=>"Book", "material_type_display"=>["a-e, iv, ii, 407 p."], "title_display"=>"Bod gaÃ¡Â¹â€¦s can gyi rgyal rabs mdor bsdus dris lan brgya pa rab gsal Ã…â€ºel gyi me loÃ¡Â¹â€¦ Ã…Âºes bya ba bÃ…Âºugs so", "id"=>"2008308202", "subject_geo_facet"=>["Tibet"], "language_facet"=>["Tibetan"], "geojson"=>["{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[91.117212, 29.646923]},\\"properties\\":{\\"placename\\":\\"Tibet\\"}}", "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Polygon\\",\\"coordinates\\":[[[78.3955448, 26.8548157], [99.116241, 26.8548157], [99.116241, 36.4833345], [78.3955448, 36.4833345], [78.3955448, 26.8548157]]]},\\"bbox\\":[78.3955448,26.8548157,99.116241,36.4833345]}"], "coordinates"=>["91.117212 29.646923", "78.3955448 26.8548157 99.116241 36.4833345"], "score"=>0.016135123}, {"published_display"=>["Dharamsala, Distt. Kangra, H.P."], "pub_date"=>["2007"], "format"=>"Book", "title_display"=>"Ses yon", "material_type_display"=>["xii, 419 p."], "id"=>"2008308478", "subject_geo_facet"=>["China", "Tibet", "India"], "subject_topic_facet"=>["Education and state", "Tibetans", "Tibetan language", "Teaching"], "language_facet"=>["Tibetan"], "geojson"=>["{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[104.195397,35.86166]},\\"properties\\":{\\"placename\\":\\"China\\"}}", "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[91.117212,29.646923]},\\"properties\\":{\\"placename\\":\\"Tibet\\"}}", "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[78.96288,20.593684]},\\"properties\\":{\\"placename\\":\\"India\\"}}","{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Polygon\\",\\"coordinates\\":[[[68.162386, 6.7535159], [97.395555, 6.7535159], [97.395555, 35.5044752], [68.162386, 35.5044752], [68.162386, 6.7535159]]]},\\"bbox\\":[68.162386,6.7535159,97.395555,35.5044752]}"], "coordinates"=>["68.162386 6.7535159 97.395555 35.5044752", "104.195397 35.86166", "91.117212 29.646923", "78.96288 20.593684"], "score"=>0.0026767207}]}, "facet_counts"=>{"facet_queries"=>{}, "facet_fields"=>{"format"=>["Book", 2], "lc_1letter_facet"=>["D - World History", 1], "lc_alpha_facet"=>["DS", 1], "lc_b4cutter_facet"=>["DS785", 1], "language_facet"=>["Tibetan", 2], "pub_date"=>["2005", 1, "2007", 1], "subject_era_facet"=>[], "subject_geo_facet"=>["China", 1, "India", 1, "Tibet", 1, "Tibet (China)", 1], "coordinates"=>["91.117212 29.646923", 2, "78.3955448 26.8548157 99.116241 36.4833345", 1, "68.162386 6.7535159 97.395555 35.5044752", 1, "104.195397 35.86166", 1, "78.96288 20.593684", 1], "geojson"=>["{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[91.117212, 29.646923]},\\"properties\\":{\\"placename\\":\\"Tibet\\"}}", 2, "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Polygon\\",\\"coordinates\\":[[[78.3955448, 26.8548157], [99.116241, 26.8548157], [99.116241, 36.4833345], [78.3955448, 36.4833345], [78.3955448, 26.8548157]]]},\\"bbox\\":[78.3955448,26.8548157,99.116241,36.4833345]}", 1, "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[104.195397,35.86166]},\\"properties\\":{\\"placename\\":\\"China\\"}}", 1, "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Point\\",\\"coordinates\\":[78.96288,20.593684]},\\"properties\\":{\\"placename\\":\\"India\\"}}", 1, "{\\"type\\":\\"Feature\\",\\"geometry\\":{\\"type\\":\\"Polygon\\",\\"coordinates\\":[[[68.162386, 6.7535159], [97.395555, 6.7535159], [97.395555, 35.5044752], [68.162386, 35.5044752], [68.162386, 6.7535159]]]},\\"bbox\\":[68.162386,6.7535159,97.395555,35.5044752]}", 1], "subject_topic_facet"=>["Education and state", 1, "Teaching", 1, "Tibetan language", 1, "Tibetans", 1]}, "facet_dates"=>{}, "facet_ranges"=>{}}, "spellcheck"=>{"suggestions"=>["tibet", {"numFound"=>1, "startOffset"=>0, "endOffset"=>5, "origFreq"=>2, "suggestion"=>[{"word"=>"tibetan", "freq"=>6}]}, "correctlySpelled", true]}})
  end

end
