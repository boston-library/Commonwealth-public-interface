module InstitutionsHelper

  # link to view all items from an institution
  def link_to_all_inst_items(link_class)
    link_to(t('blacklight.institutions.browse.all'),
            catalog_index_path(:f => {blacklight_config.institution_field => [@institution_title]}),
            :class => link_class)
  end

  # replaces render_document_index in institutions/index partial
  # so we can use local index_map_institutions partial for map view
  def render_institutions_index documents = nil, locals = {}
    documents ||= @document_list
    if document_index_view_type.to_s == 'maps'
      render :partial => 'catalog/index_map_institutions',
             :locals => {:geojson_features => serialize_geojson(map_facet_values,
                                                                nil,
                                                                {partial: 'institutions/map_institutions_search'})}
    else
      render_document_index_with_view(document_index_view_type, documents, locals)
    end
  end

end