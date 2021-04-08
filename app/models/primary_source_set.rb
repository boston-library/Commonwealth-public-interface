# frozen_string_literal: true

class PrimarySourceSet
  JSON_TEMPLATE_PATH = Rails.root.join('app', 'views', 'primary_source_sets', 'json_templates').freeze

  def initialize(json_template_name = nil)
    template_path = File.join(JSON_TEMPLATE_PATH, "#{json_template_name}.json")
    return nil unless File.exist?(template_path)

    @set_data = JSON.parse(File.read(template_path))
  end

  def title
    @set_data.fetch('title', '')
  end

  def intro_text
    @set_data.fetch('intro_text', '')
  end

  def item_documents
    docs_for_ids('item_ids')
  end

  def collection_documents
    docs_for_ids('collections')
  end

  def menu_items
    @set_data.fetch('menu_items', [])
  end

  def parent
    @set_data.fetch('parent', nil)
  end

  def subjects
    @set_data.fetch('subjects', [])
  end

  private

  def docs_for_ids(key)
    ids_to_find = @set_data.fetch(key, [])
    return [] if ids_to_find.blank?

    begin
      solr_resp = SolrDocument.find(ids_to_find)
      return [] if solr_resp.response.blank?

      solr_resp.response.docs
    rescue Blacklight::Exceptions::RecordNotFound, Blacklight::Exceptions::ECONNREFUSED
      []
    end
  end
end
