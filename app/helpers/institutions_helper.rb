module InstitutionsHelper

  # link to view all items from an institution
  def link_to_all_inst_items(link_class)
    link_to(t('blacklight.institutions.browse.all'),
            catalog_index_path(:f => {'institution_name_ssim' => [@institution_title]}),
            :class => link_class)
  end

  def should_autofocus_on_search_box?
    action_name == 'show' ? true : false
  end

end