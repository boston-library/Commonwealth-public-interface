class PreviewController < CatalogController

  # give Preview access to useful BL/Solr methods
  include Blacklight::SolrHelper

  #copy_blacklight_config_from(CatalogController)

  def show
    #@pid = params[:id].to_s
    @response, @document = get_solr_response_for_doc_id
    unless @document.nil?
      @image_pid = @document[:has_image_s].first.to_s.gsub(/info:fedora\//,"")
      thumb_prefix = @document[:id].to_s
      @thumb_datastream_url = view_context.datastream_disseminator_url(@image_pid, "thumbnail300")
      response = Typhoeus::Request.get(@thumb_datastream_url)
      send_data response.body,
                :filename => thumb_prefix + '_thumbnail.jpg',
                :type => :jpg,
                :disposition => 'inline'
    else
      redirect_to root_path
    end

  end

  private

  def get_thumb_url(pid)
    #@response, @document = get_solr_response_for_doc_id(pid)


    #thumb_url = 'http://fedoratest.bpl.org:8581/fedora/objects/bpl-test:mc87pr89k/datastreams/thumbnail300/content'
    #return thumb_url

    # item = Bplmodels::ObjectBase.find("bpl-test:mc87pq30p")
    # item.datastreams
    # item.rels_ext
    # relsext-rdf = item.rels_ext.relationships # returns an RDF::Graph object
    # relsext-rdf.triples    # returns an enumerator of triples
    # relsext-rdf.triples.first  # returns an triple as an array
    # relsext-rdf.triples.first.[0]  # access one part of a triple, call to_s, etc.




  end

end
