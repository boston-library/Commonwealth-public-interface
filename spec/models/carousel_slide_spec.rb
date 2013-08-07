require 'spec_helper'

describe CarouselSlide do
  require 'spec_helper'

  before(:each) do
    @slide_attr = {
      :sequence => 1,
      :object_pid => 'bpl-test:123456',
      :image_pid => 'bpl-test:7891011',
      :scale => 300,
      :region => '250,90,295,570',
      :title => 'The Slide Title',
      :institution => 'Institution Name',
      :context => 'bpl-test:0022331'
    }
  end

  it "should create a new slide given valid attributes" do
    @slide = CarouselSlide.create!(@slide_attr)
  end

end
