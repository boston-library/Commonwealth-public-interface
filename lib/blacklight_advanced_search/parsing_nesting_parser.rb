require 'parsing_nesting/tree'
module BlacklightAdvancedSearch::ParsingNestingParser

  # LOCAL OVERRIDE
  def process_query(params,config)
    queries = []
    keyword_queries.each do |field,query|
      queries << ParsingNesting::Tree.parse(query).to_query( local_param_hash(field, config)  )
    end
    queries << add_date_range_to_queries(params) unless params[:date_start].blank? && params[:date_end].blank?
    queries.join( ' ' + keyword_op + ' ')
  end

  # LOCAL ADDITION
  def add_date_range_to_queries(params)
    range_start = params[:date_start].blank? ? '*' : params[:date_start]
    range_end = params[:date_end].blank? ? '*' : params[:date_end]
    date_query = 'date_start_tsim:[' + range_start + ' TO ' + range_end + ']'
    date_query
  end

  def local_param_hash(key, config)
    field_def = config.search_fields[key]

    (field_def[:solr_parameters] || {}).merge(field_def[:solr_local_parameters] || {})
  end

end
