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
    scale_factors = []
    metadata.levels.to_i.times { |n| scale_factors << 2**n }
    iiif_metadata = {
        '@context' => 'http://library.stanford.edu/iiif/image-api/1.1/context.json',
        '@id' => params[:identifier],
        'width' => metadata.width.to_i,
        'height' => metadata.height.to_i,
        'scale_factors' => scale_factors,
        'tile_width' => 256,
        'tile_height' => 256,
        'formats' => ['jpg', 'png'],
        'qualities' => ['native', 'grey'],
        'profile' => 'http://library.stanford.edu/iiif/image-api/compliance.html#level1'
    }
    render :json => iiif_metadata.to_json
  end

end