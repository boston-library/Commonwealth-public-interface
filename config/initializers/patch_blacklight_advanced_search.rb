# have to override some methods from BlacklightAdvancedSearch
# to provide search-field drop-down options and date limiter

require BlacklightAdvancedSearch::Engine.root.join(Rails.root, 'config','initializers','patch_blacklight_advanced_search')

class BlacklightAdvancedSearch::QueryParser

  # LOCAL OVERRIDE of BlacklightAdvancedSearch::ParsingNestingParser#process_query
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

  # LOCAL ADDITION change params to be what's expected by gem
  def prepare_params(params)
    if params[:search_index]
      params[:search_index].each_with_index do |field,index|
        if params[field.to_sym] # check if field is set
          unless params[:query][index].empty?
            if params[:op] == 'OR'
              params[field.to_sym] = params[field.to_sym] + ' OR ' + params[:query][index]
            else
              params[field.to_sym] = params[field.to_sym] + ' AND ' + params[:query][index]
            end
          else
            params[field.to_sym] = params[field.to_sym]
          end
        else
          params[field.to_sym] = params[:query][index]
        end
      end
      params.delete(:search_index)
      params.delete(:query)
    end
    params
  end

  # LOCAL OVERRIDE of BlacklightAdvancedSearch::QueryParser#initialize
  def initialize(params,config)
    @params = HashWithIndifferentAccess.new(prepare_params(params))
    @config = config
  end



end