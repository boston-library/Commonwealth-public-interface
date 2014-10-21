module ApplicationHelper

  # show the display-friendly value for the Format facet
  def render_format value
    case value
      when 'Albums'
        'Albums/Scrapbooks'
      when 'Drawings'
        'Drawings/Illustrations'
      when 'Maps'
        'Maps/Atlases'
      when 'Documents'
        'Documents'
      when 'Motion pictures'
        'Film/Video'
      when 'Music'
        'Music (recordings)'
      when 'Objects'
        'Objects/Artifacts'
      when 'Prints'
        'Prints'
      when 'Musical notation'
        'Sheet music'
      when 'Sound recordings'
        'Audio recordings (nonmusical)'
      when 'Cards'
        'Postcards/Cards'
      when 'Correspondence'
        'Letters/Correspondence'
      else
        value
    end
  end

  # show the icon for objects with no thumbnail
  def render_object_icon(format, img_class)
    case format
      when 'sound recording'
        icon = 'audio'
      when 'still image'
        icon = 'image'
      when 'moving image'
        icon = 'moving-image'
      else
        icon = 'text'
    end
    image_tag('dc_' + icon +'-icon.png', :class => img_class, :alt => icon + ' icon')
  end

  #from psu scholarsphere
  def link_to_field(fieldname, fieldvalue, displayvalue = nil)
    p = {:search_field => fieldname, :q => '"'+fieldvalue+'"'}
    link_url = catalog_index_path(p)
    display = displayvalue.blank? ? fieldvalue: displayvalue
    link_to(display, link_url)
  end

  def link_to_facet(field_value, field, displayvalue = nil)
    if field == 'genre_basic_ssim'
      link_to(render_format(field_value), catalog_index_path(:f => {field => [field_value]}))
    else
      link_to(displayvalue.presence || field_value, catalog_index_path(:f => {field => [field_value]}))
    end
  end

  # link to a combination of facets (series + subseries, for ex)
  def link_to_facets(field_values, fields, displayvalue = nil)
   facets = {}
    fields.each_with_index do |field, index|
      facets[field] = [field_values[index]]
    end
    link_to(displayvalue.presence || field_values[0], catalog_index_path(:f => facets))
  end

  def link_to_county_facet(field_value, field)
    link_to(field_value + ' County', catalog_index_path(:f => {field => [field_value + ' (county)']}))
  end

  def datastream_disseminator_url pid, datastream_id
    ActiveFedora::Base.connection_for_pid(pid).client.url + "/objects/#{pid}/datastreams/#{datastream_id}/content"
  end

  # create djatoka-friendly non-ssl image path
  def nonssl_image_uri(pid,datastream_id)
    datastream_disseminator_url(pid,datastream_id).gsub(/\Ahttps/,'http')
  end

  # create an image tag from an IIIF image server
  def iiif_image_tag(image_pid,options)
    size = options[:size] ? options[:size] : 'full'
    region = options[:region] ? options[:region] : 'full'
    url = "#{IIIF_SERVER['url']}#{image_pid}/#{region}/#{size}/0/default.jpg"
    image_tag url, :alt => options[:alt].presence, :class => options[:class].presence
  end

  # returns a hash with width/height from IIIF info.json response
  def get_image_metadata(image_pid)
    iiif_response = Typhoeus::Request.get(IIIF_SERVER['url'] + image_pid + '/info.json')
    if iiif_response.response_code == 200
      iiif_info = JSON.parse(iiif_response.body)
      img_metadata = {:height => iiif_info["height"].to_i, :width => iiif_info["width"].to_i}
    else
      img_metadata = {:height => 0, :width => 0}
    end
    img_metadata
  end

  def insert_google_analytics
    if Rails.env.to_s == 'production'
      content_for(:head) do
        render :partial=>'/layouts/google_analytics'
      end
    end
  end

end
