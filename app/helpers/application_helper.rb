module ApplicationHelper

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
    new_params[:action] = "index"
    new_params[:controller] = "catalog"
    new_params[:f] = {field_string => [field]}
    link_to(field, new_params)
  end

  def link_to_facet_labeled(link_text, field, field_string)
    link_to(link_text,
            add_facet_params(field_string, field).merge!({"controller" => "catalog",
                                                                 :action=> "index"}))
  end

  def simpleimage_file_pid (document)
    return Bplmodels::Image.find(document[:id]).image_files.first.pid
  end

  def datastream_disseminator_url pid, datastream_id
    ActiveFedora::Base.connection_for_pid(pid).client.url + "/objects/#{pid}/datastreams/#{datastream_id}/content"
  end

  def render_mods_dates (date_start, date_end = nil, date_qualifier = nil)
    prefix = ''
    suffix = ''
    connector = ''
    if date_qualifier
      date_qualifier == 'approximate' ? prefix = '[ca. ' : prefix = '['
      date_qualifier == 'questionable' ? suffix = '?]' : suffix =']'
    end
    if date_end
      date_qualifier == 'questionable' ? connector = '?–' : connector = '–'
      prefix + date_start + connector + date_end + suffix
    else
      prefix + date_start + suffix
    end
  end

end
