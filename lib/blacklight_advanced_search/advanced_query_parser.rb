module BlacklightAdvancedSearch
  class QueryParser
    include ParsingNestingParser # only one strategy currently supported. if BlacklightAdvancedSearch.config[:solr_type] == "parsing_nesting"
    include FilterParser
    attr_reader :config, :params

    # change params to be what's expected by gem
    def prepare_params(params)
      if params[:search_index]
        params[:search_index].each_with_index do |field,index|
          params[field.to_sym] = params[:query][index]
        end
        params.delete(:search_index)
        params.delete(:query)
      end
      params
    end

    def initialize(params,config)
      puts "INITIALIZE called"
      @params = HashWithIndifferentAccess.new(prepare_params(params))
      @config = config
    end

    def to_solr
      puts "TO_SOLR called"
      @to_solr ||= begin
        {
            :q => process_query(params,config),
            :fq => generate_solr_fq()
        }
      end
    end

    # Returns "AND" or "OR", how #keyword_queries will be combined
    def keyword_op
      puts "KEYWORD_OP called"
      @params["op"] || "AND"
    end
    # returns advanced-type keyword queries, see also keyword_op
    def keyword_queries
      puts "KEYWORD_QUERIES called"
      unless(@keyword_queries)
        @keyword_queries = {}

        return @keyword_queries unless @params[:search_field] == ::AdvancedController.blacklight_config.advanced_search[:url_key]

        config.search_fields.each do | key, field_def |
          if ! @params[ key.to_sym ].blank?
            @keyword_queries[ key ] = @params[ key.to_sym ]
          end
        end
      end
      return @keyword_queries
    end
    # returns just advanced-type filters
    def filters
      puts "FILTERS called"
      unless (@filters)
        @filters = {}
        return @filters unless @params[:f_inclusive]
        @params[:f_inclusive].each_pair do |field, value_hash|
          value_hash.each_pair do |value, type|
            @filters[field] ||= []
            @filters[field] << value
          end
        end
      end
      return @filters
    end

    def empty?
      filters.empty? && keyword_queries.empty?
    end

  end
end
