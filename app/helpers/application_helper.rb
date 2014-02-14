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

  def link_to_facet(field, field_string)
    new_params = add_facet_params(field_string, field)
    new_params.delete(:id)
    new_params.delete(:view)
    new_params[:action] = 'index'
    new_params[:controller] = 'catalog'
    new_params[:f] = {field_string => [field]}
    if field_string == 'genre_basic_ssim'
      link_to(render_format(field), new_params)
    else
      link_to(field, new_params)
    end
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

  def simpleimage_file_pid (document)
    return Bplmodels::Image.find(document[:id]).image_files.first.pid
  end

  def render_item_breadcrumb(document)
    if document[:institution_pid_ssi] && document[:collection_pid_ssm]
      inst_link = link_to(document[:institution_name_ssim].first,
                          institution_path(:id => document[:institution_pid_ssi]),
                          :class => 'institution_breadcrumb')
      connector = content_tag(:i, '',
                              :class => 'icon-arrow-right item-breadcrumb-separator')
      coll_link = link_to(document[:collection_name_ssim].first,
                          collection_path(:id => document[:collection_pid_ssm].first),
                          :class => 'collection_breadcrumb')
      inst_link + connector + coll_link
    end
  end

  def datastream_disseminator_url pid, datastream_id
    ActiveFedora::Base.connection_for_pid(pid).client.url + "/objects/#{pid}/datastreams/#{datastream_id}/content"
  end

  # create djatoka-friendly non-ssl image path
  def nonssl_image_uri(pid,datastream_id)
    datastream_disseminator_url(pid,datastream_id).gsub(/\Ahttps/,'http')
  end

  def render_mods_dates (date_start, date_end = nil, date_qualifier = nil, date_type = nil)
    prefix = ''
    suffix = ''
    date_start_suffix = ''
    if date_qualifier
      prefix = date_qualifier == 'approximate' ? '[ca. ' : '['
      suffix = date_qualifier == 'questionable' ? '?]' : ']'
    end
    prefix << 'c' if date_type == 'copyrightDate'
    if date_end && date_end != 'nil'
      date_start_suffix = '?' if date_qualifier == 'questionable'
      prefix + normalize_date(date_start) + date_start_suffix + t('blacklight.metadata_display.fields.date.date_range_connector') + normalize_date(date_end) + suffix
    else
      prefix + normalize_date(date_start) + suffix
    end
  end

  def render_mods_xml_record(document_id)
    mods_xml_file_path = datastream_disseminator_url(document_id, 'descMetadata')
    mods_response = Typhoeus::Request.get(mods_xml_file_path)
    mods_xml_text = REXML::Document.new(mods_response.body)
  end

  def normalize_date(date)
    if date.length == 10
      Date.parse(date).strftime('%B %-d, %Y')
    elsif date.length == 7
      Date.parse(date + '-01').strftime('%B %Y')
    else
      date
    end
  end

  # insert an icon and link to CC licenses
  def render_cc_license(terms)
    terms_code = terms.match(/\s[BYNCDSA-]{2,}/).to_s.strip.downcase
    link_to(image_tag('//i.creativecommons.org/l/' + terms_code + '/3.0/80x15.png',
                      :alt => 'CC ' + terms_code.upcase + ' icon',
                      :class => 'cc_license_icon'),
            'http://creativecommons.org/licenses/' + terms_code + '/3.0',
            :rel => 'license',
            :id => 'cc_license_link',
            :target => '_blank')
  end

end
