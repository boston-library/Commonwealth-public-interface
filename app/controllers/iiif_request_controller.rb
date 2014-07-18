# take an IIIF-compliant image request and pass it through to Djatoka
class IiifRequestController < ApplicationController

  def show
    @incoming_url = request.fullpath
  end

end