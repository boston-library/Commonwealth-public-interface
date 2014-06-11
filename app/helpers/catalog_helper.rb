module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def create_download_links(files_hash, link_class)
    file_types = [files_hash[:documents], files_hash[:audio], files_hash[:generic]]
    download_links = []
    file_types.each do |file_type|
      file_type.each do |file|
        object_profile_json = JSON.parse(file['object_profile_ssm'].first)
        file_name_ext = object_profile_json["objLabel"].split('.')
        download_links << link_to(file_name_ext[0],
                                  download_path(file['id'],:datastream_id => 'productionMaster')                                  ,
                                  :target => '_blank',
                                  :class => link_class) + content_tag(:span, '(' + file_name_ext[1].upcase + ', ' + number_to_human_size(object_profile_json["datastreams"]["productionMaster"]["dsSize"]) + ')', :class => 'download_info')
      end
    end
    download_links
  end

  def extra_body_classes
    @extra_body_classes ||= ['blacklight-' + controller.controller_name, 'blacklight-' + [controller.controller_name, controller.action_name].join('-')]
    # if this is the home page
    if controller.controller_name == 'pages' && controller.action_name =='home'
      @extra_body_classes.push('blacklight-home')
    else
      @extra_body_classes
    end
  end

  def has_downloadable_files? files_hash
    files_hash[:documents].present? ||
        files_hash[:audio].present? ||
        files_hash[:generic].present?
  end

  def has_image_files? files_hash
    image_file_pids = nil
    unless files_hash[:images].empty?
      image_file_pids = []
      files_hash[:images].each do |image_file|
        image_file_pids << image_file['id']
      end
    end
    image_file_pids
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

  # have to override this because of a bug in BL
  # submitted issue #908 on projectblacklight/blacklight GitHub
  def render_document_class(document = @document)
    'blacklight-' + document.get(blacklight_config.view_config(document_index_view_type).display_type_field).parameterize rescue nil
  end

  def render_item_breadcrumb(document)
    if document[:institution_pid_ssi] && document[:collection_pid_ssm]
      inst_link = link_to(document[:institution_name_ssim].first,
                          institution_path(:id => document[:institution_pid_ssi]),
                          :class => 'institution_breadcrumb')
      connector = content_tag(:span, '',
                              :class => 'glyphicon glyphicon-arrow-right item-breadcrumb-separator')
      coll_link = link_to(document[:collection_name_ssim].first,
                          collection_path(:id => document[:collection_pid_ssm].first),
                          :class => 'collection_breadcrumb')
      inst_link + connector + coll_link
    end
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

  def create_thumb_img_element(document, img_class=[])
    image_classes = img_class.join(' ')
    if document[:exemplary_image_ssi] and !document[blacklight_config.flagged_field.to_sym]
      image_tag(datastream_disseminator_url(document[:exemplary_image_ssi], 'thumbnail300'),
                :alt => document[blacklight_config.index.title_field.to_sym],
                :class => image_classes)
    elsif document[:type_of_resource_ssim]
      render_object_icon(document[:type_of_resource_ssim].first, image_classes)
    elsif document[blacklight_config.index.display_type_field.to_sym] == 'Collection'
      image_tag('dc_collection-icon.png',
                :alt => document[blacklight_config.index.title_field.to_sym],
                :class => image_classes)
    else
      render_object_icon(nil, image_classes)
    end
  end

  def should_autofocus_on_search_box?
    (controller.is_a? Blacklight::Catalog and
        action_name == "index" and
        params[:q].to_s.empty? and
        params[:f].to_s.empty?) or
    (controller.is_a? PagesController and action_name == 'home')
  end

end