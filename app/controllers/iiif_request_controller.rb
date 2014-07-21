# take an IIIF-compliant image request and pass it through to Djatoka
class IiifRequestController < ApplicationController

  include ApplicationHelper

  # return an image
  def show
    iiif_request = Djatoka::IiifRequest.new(Djatoka::Resolver.new(Rails.configuration.djatoka_resolver.base_url), nonssl_image_uri(params[:identifier],'accessMaster'))
    djatoka_params = iiif_request.region(params[:region]).size(params[:size]).rotation(params[:rotation]).quality(params[:quality]).format(params[:format]).djatoka_region
    #@djatoka_url = djatoka_params.url
    redirect_to djatoka_params.url
  end

  # return info.json
  def info
    metadata = Rails.configuration.djatoka_resolver.metadata(nonssl_image_uri(params[:identifier],'accessMaster')).perform
    json = metadata.to_iiif_json do |info|
      info.tile_width   = 256
      info.tile_height  = 256
      info.formats      = ['jpg', 'png']
      info.qualities    = ['native', 'grey']
      info.profile      = 'http://library.stanford.edu/iiif/image-api/compliance.html#level1'
      info.context      = 'http://library.stanford.edu/iiif/image-api/1.1/context.json'
      # info.image_host   = 'http://localhost:3000/iiif'
    end


  end

  private

  def fedora_configs
    {
        :fedora_base_url => ActiveFedora::Base.connection_for_pid('abc123').config.url,
        :fedora_path_prefix => '/objects/',
        :fedora_path_suffix => '/datastreams/accessMaster/'
    }

  end

end