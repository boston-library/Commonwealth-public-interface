module CollectionsHelper

  # link to view all items in a collection
  def link_to_all_col_items(link_class)
    link_to(t('blacklight.collections.browse.all'),
            catalog_index_path(:f => {blacklight_config.collection_field => [@collection_title]}),
            :class => link_class)
  end

end
