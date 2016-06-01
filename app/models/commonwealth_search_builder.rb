class CommonwealthSearchBuilder < Blacklight::SearchBuilder

  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include CommonwealthVlrEngine::CommonwealthSearchBuilderBehavior

  self.default_processor_chain += [
      :exclude_unwanted_models, :exclude_unpublished_items,
      :exclude_volumes, :add_advanced_parse_q_to_solr, :add_advanced_search_to_solr
  ]

  if t('blacklight.home.browse.institutions.enabled')
    self.default_processor_chain += [:institution_limit]
  end

end