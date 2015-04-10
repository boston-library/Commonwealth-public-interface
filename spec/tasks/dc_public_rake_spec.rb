require 'spec_helper'
require 'rake'

describe 'dc_public namespace rake tasks' do

  before :all do
    Rake.application.rake_require 'tasks/dc_public'
    Rake::Task.define_task(:environment)
    @time = Time.now.to_f
  end

  describe 'dc_public:create_geojson' do

    let :run_rake_task do
      Rake::Task['dc_public:create_geojson'].reenable
      Rake.application.invoke_task 'dc_public:create_geojson'
    end

    it 'should create the geojson file' do
      run_rake_task
      expect(File.file?(GEOJSON_STATIC_FILE['filepath'])).not_to be_nil
      expect(File.stat(GEOJSON_STATIC_FILE['filepath']).mtime.to_f).to be > @time
    end

  end

end