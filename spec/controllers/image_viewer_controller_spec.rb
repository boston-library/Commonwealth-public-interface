require 'spec_helper'

describe ImageViewerController do

  render_views

  describe "GET 'show'" do
    it 'should render the partial using ajax with the new image' do
      xhr :get, :show, :id => 'bpl-test:xg94hp59s', :view => 'bpl-test:xg94hp61t'
      response.should be_success
      # not great, but OK for now
      response.body.should match /fedora%2Fobjects%2Fbpl-test%3Axg94hp61t%2Fdatastreams%2FaccessMaster/
    end
  end

end