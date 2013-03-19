class PreviewController < ApplicationController

  def show
    @pid = params[:id]
    @image_url = get_thumb_url(@pid)
    response = Typhoeus::Request.get(@image_url)
    send_data response.body,
              :filename => 'thumbnail.jpg',
              :type => :jpg,
              :disposition => 'inline'
    #redirect_to @image_url
  end

  private

  def get_thumb_url(pid)
    thumb_url = 'http://fedoratest.bpl.org:8581/fedora/objects/bpl-test:mc87pr89k/datastreams/thumbnail300/content'
    return thumb_url

    # item = Bplmodels::ObjectBase.find("bpl-test:mc87pq30p")
    # item.datastreams
    # item.rels_ext
    # relsext-rdf = item.rels_ext.relationships # returns an RDF::Graph object
    # relsext-rdf.triples    # returns an enumerator of triples
    # relsext-rdf.triples.first  # returns an triple as an array
    # relsext-rdf.triples.first.[0]  # access one part of a triple, call to_s, etc.




  end

end
