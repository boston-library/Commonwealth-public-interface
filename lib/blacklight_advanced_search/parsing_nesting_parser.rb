require 'parsing_nesting/tree'
module BlacklightAdvancedSearch::ParsingNestingParser

  # LOCAL OVERRIDE
  def process_query(params,config)
    queries = []
    keyword_queries.each do |field,query|
      queries << ParsingNesting::Tree.parse(query).to_query( local_param_hash(field, config)  )
    end
    if params[:date_start].blank? && params[:date_end].blank?
      queries.join( ' ' + keyword_op + ' ')
    else
      queries.join( ' ' + keyword_op + ' ') + ' AND ' + add_date_range_to_queries(params)
    end
  end

  # LOCAL ADDITION
  def add_date_range_to_queries(params)
    range_start = params[:date_start].blank? ? '*' : params[:date_start] + '-01-01T00:00:00.000Z'
    range_end = params[:date_end].blank? ? '*' : params[:date_end] + '-12-31T23:59:59.999Z'
    date_query = 'date_start_dtsi:[' + range_start + ' TO ' + range_end + ']'
    date_query
  end

  def local_param_hash(key, config)
    field_def = config.search_fields[key]

    (field_def[:solr_parameters] || {}).merge(field_def[:solr_local_parameters] || {})
  end

end
