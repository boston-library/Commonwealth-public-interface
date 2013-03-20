class PreviewController < CatalogController

  # give Preview access to useful BL/Solr methods
  include Blacklight::SolrHelper

  def show
    #@response, @document = get_solr_response_for_doc_id
    @document = get_solr_response_for_doc_id
    unless @document.nil?

        thumb_prefix = @document[1][:id].to_s
        @image_pid = @document[1][:has_image_s].first.to_s.gsub(/info:fedora\//,"")
        @thumb_datastream_url = view_context.datastream_disseminator_url(@image_pid, "thumbnail300")
        response = Typhoeus::Request.get(@thumb_datastream_url)
        send_data response.body,
                  :filename => thumb_prefix + '_thumbnail.jpg',
                  :type => :jpg,
                  :disposition => 'inline'

    else
      #not_found
      #@whatever = "whatever"
      render_template = false
      redirect_to root_path
    end
    #unless @document.nil?
      #redirect_to root_path

    #else
      #redirect_to root_path
    #  @nil_message = "this shouldn't exist"
    #end

  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def get_thumb_url(pid)
    # item = Bplmodels::ObjectBase.find("bpl-test:mc87pq30p")
    # item.datastreams
    # item.rels_ext
    # relsext-rdf = item.rels_ext.relationships # returns an RDF::Graph object
    # relsext-rdf.triples    # returns an enumerator of triples
    # relsext-rdf.triples.first  # returns an triple as an array
    # relsext-rdf.triples.first.[0]  # access one part of a triple, call to_s, etc.
  end

end
