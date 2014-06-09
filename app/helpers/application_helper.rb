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

  #from psu scholarsphere
  #def link_to_facet(field, field_string)
  #  link_to(field, add_facet_params(field_string, field).merge!({"controller" => "catalog",
  #                                                               :action=> "index"}))
  #end

  def link_to_facet(field_value, field)
    new_params = add_facet_params(field, field_value)
    new_params.delete(:id)
    new_params.delete(:view)
    new_params[:action] = 'index'
    new_params[:controller] = 'catalog'
    new_params[:f] = {field => [field_value]}
    if field == 'genre_basic_ssim'
      link_to(render_format(field_value), new_params)
    else
      link_to(field_value, new_params)
    end
  end

  # link to a combination of facets (series + subseries, for ex)
  def link_to_facets(field_values, fields)
    new_params = params
    new_params.delete(:id)
    new_params.delete(:view)
    new_params[:action] = 'index'
    new_params[:controller] = 'catalog'
    new_params[:f] = {}
    fields.each_with_index do |field, index|
      new_params[:f][field] = [field_values[index]]
    end
    link_to(field_values[0], new_params)
  end

  def link_to_facet_labeled(link_text, field, field_string)
    link_to(link_text,
            add_facet_params(field_string, field).merge!({'controller' => 'catalog',
                                                                 :action=> 'index'}))
  end

  def link_to_county_facet(field, field_string)
    new_params = add_facet_params(field_string, field + ' (county)')
    new_params.delete(:id)
    new_params.delete(:view)
    new_params[:action] = 'index'
    new_params[:controller] = 'catalog'
    new_params[:f] = {field_string => [field + ' (county)']}
    link_to(field + ' County', new_params)
  end

  def datastream_disseminator_url pid, datastream_id
    ActiveFedora::Base.connection_for_pid(pid).client.url + "/objects/#{pid}/datastreams/#{datastream_id}/content"
  end

  # create djatoka-friendly non-ssl image path
  def nonssl_image_uri(pid,datastream_id)
    datastream_disseminator_url(pid,datastream_id).gsub(/\Ahttps/,'http')
  end

  def insert_google_analytics
    if Rails.env.to_s == 'production'
      content_for(:head) do
        render :partial=>'/layouts/google_analytics'
      end
    end
  end

end
