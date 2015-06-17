class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  def institution_limit(solr_parameters = {})
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << '+institution_pid_ssi:"' + view_context.t('blacklight.institution_pid') + '"'
  end

end
