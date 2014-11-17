require 'spec_helper'

describe PreviewController do

  describe 'GET #preview' do

    it 'should return the thumbnail if one exists' do
      get :preview, :id => 'bpl-dev:k930bx42b'
      expect(response).to be_success
      response.header['Content-Type'].should == 'image/jpeg'
    end

    it 'should return the image icon if this is a flagged item' do
      get :preview, :id => 'bpl-dev:9880vr198'
      expect(response).to be_success
      response.header['Content-Type'].should == 'image/png'
    end

    it 'should return a 404 error if no image exists' do
      get :preview, :id => 'xyz123'
      expect(response).to_not be_success
      response.response_code.should == 404
    end

  end

  describe 'GET #full' do

    # doesn't pass for now; try again once we get IIIF server dev instance working
    it 'should return the full image if one exists' do
      get :full, :id => 'bpl-dev:k930bx42b'
      expect(response).to be_success
      response.header['Content-Type'].should == 'image/jpeg'
    end

    it 'should return the image icon if this is a flagged item' do
      get :full, :id => 'bpl-dev:9880vr198'
      expect(response).to be_success
      response.header['Content-Type'].should == 'image/png'
    end

    it 'should return a 404 error if no image exists' do
      get :full, :id => 'xyz123'
      expect(response).to_not be_success
      response.response_code.should == 404
    end

  end

end
