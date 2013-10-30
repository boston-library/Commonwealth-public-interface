class PreviewController < CatalogController

  # give Preview access to useful BL/Solr methods
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)

  def show
    @response, @document = get_solr_response_for_doc_id
    # the conditionals below don't really work, because a bad id returned by
    # get_solr_response_for_doc_id triggers a rescue action in BL/lib/catalog.rb,
    # which causes an immediate escape, and any code below that isn't evaluated
    # need to figure out how to override this
    if @document[:exemplary_image_ssi]
      thumb_prefix = @document[:id].to_s
      @image_pid = @document[:exemplary_image_ssi]
      @thumb_datastream_url = view_context.datastream_disseminator_url(@image_pid, 'thumbnail300')
      response = Typhoeus::Request.get(@thumb_datastream_url)
      if response.headers[/404 Not Found/]
        not_found
      else
        send_data response.body,
                  :filename => thumb_prefix + '_thumbnail.jpg',
                  :type => :jpg,
                  :disposition => 'inline'
      end
    else
      not_found
    end

  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  #def get_thumb_url(pid)
    # item = Bplmodels::ObjectBase.find("bpl-test:mc87pq30p")
    # item.datastreams
    # item.rels_ext
    # relsext-rdf = item.rels_ext.relationships # returns an RDF::Graph object
    # relsext-rdf.triples    # returns an enumerator of triples
    # relsext-rdf.triples.first  # returns an triple as an array
    # relsext-rdf.triples.first.[0]  # access one part of a triple, call to_s, etc.
  #end

end
