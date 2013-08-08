require 'spec_helper'

describe CarouselSlide do

  before(:each) do
    @slide_attr = {
      :sequence => 1,
      :object_pid => 'bpl-test:123456',
      :image_pid => 'bpl-test:7891011',
      :scale => 300,
      :region => [250,90,295,570],
      :title => 'The Slide Title',
      :institution => 'Institution Name',
      :context => 'bpl-test:0022331'
    }
  end

  it 'should create a new slide given valid attributes' do
    CarouselSlide.create!(@slide_attr)
  end

  describe 'assign values properly' do

    before(:each) do
      @slide = CarouselSlide.create!(@slide_attr)
    end

    it 'should have a title attribute' do
      @slide.should respond_to(:title)
    end

    it 'should have the right title' do
      @slide.title.should == 'The Slide Title'
    end

    it 'should store region data as an Array' do
      @slide.region.class.should == Array
    end

  end

end
