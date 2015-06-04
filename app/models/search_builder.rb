class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  # used by InstitutionsController#index
  def institutions_filter(solr_parameters = {})
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "+active_fedora_model_suffix_ssi:\"Institution\""
  end

end
