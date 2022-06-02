# filestream_disseminator_url(document[:exemplary_image_key_base_ss], 'image_thumbnail_300')
# frozen_string_literal: true

module PrimarySourceSetsHelper

  # return the URL for the primary source set menu item
  # @param menu_item_data [Hash]
  # @return [String]
  def pss_thumbnail_url(menu_item_data)
    image_ark_id = menu_item_data.fetch('thumbnail_id', '')
    if image_ark_id.match?(/-oai:/)
      filestream_disseminator_url("metadata/#{image_ark_id}", 'image_thumbnail_300')
    else
      iiif_image_url(image_ark_id, { region: 'square', size: '300,' })
    end
  end
end
