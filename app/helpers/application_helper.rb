module ApplicationHelper

  #from psu scholarsphere
  def link_to_field(fieldname, fieldvalue, displayvalue = nil)
    p = {:search_field => fieldname, :q => '"'+fieldvalue+'"'}
    link_url = catalog_index_path(p)
    display = displayvalue.blank? ? fieldvalue: displayvalue
    link_to(display, link_url)
  end

  #from psu scholarsphere
  def link_to_facet(field, field_string)
    link_to(field, add_facet_params(field_string, field).merge!({"controller" => "catalog",
                                                                 :action=> "index"}))
  end

end
