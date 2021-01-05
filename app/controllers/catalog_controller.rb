# frozen_string_literal: true

class CatalogController < ApplicationController
  include Blacklight::Catalog

  # CatalogController-scope behavior and configuration for BlacklightIiifSearch
  include BlacklightIiifSearch::Controller

  # CatalogController-scope behavior and configuration for CommonwealthVlrEngine
  include CommonwealthVlrEngine::ControllerOverride

  configure_blacklight do |config|
    # SearchBuilder contains logic for adding search params to Solr
    config.search_builder_class = CommonwealthSearchBuilder
    config.fetch_many_document_params = { fl: '*' }

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:folder_items, partial: 'folder_item_control')
    config.add_show_tools_partial(:email, partial: 'show_email_tools', callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:citation, partial: 'show_cite_tools')

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar

    # IMPORTANT: most facets are set in CommonwealthVlrEngine::ControllerOverride

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    # next line deprecated as of BL 3.7.0
    # config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    config.add_facet_fields_to_solr_request!
    # use this instead if you don't want to query facets marked :show=>false
    # config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display

    # IMPORTANT: most index_fields are set in CommonwealthVlrEngine::ControllerOverride

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display

    # IMPORTANT: show fields are set in
    # commonwealth-vlr-engine/app/views/_show_partials/_show_default_metadata
    # config.add_show_field 'title_t', :label => 'Title:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # IMPORTANT: search fields are set in CommonwealthVlrEngine::ControllerOverride

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).

    # IMPORTANT: sort fields are set in CommonwealthVlrEngine::ControllerOverride

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'

    # advanced search facet limits
    config.advanced_search[:form_solr_parameters]['facet.field'] = ['genre_basic_ssim', 'physical_location_ssim']
    config.advanced_search[:form_solr_parameters]['f.physical_location_ssim.facet.limit'] = -1
    config.advanced_search[:form_solr_parameters]['f.physical_location_ssim.facet.sort'] = 'index'
  end
end
