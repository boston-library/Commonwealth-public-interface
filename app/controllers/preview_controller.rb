class PreviewController < CatalogController

  # give Preview access to useful BL/Solr methods
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)

  # return an image file for <mods:url access='preview'> requests
  # for flagged items, return the image icon
  def show
    @response, @document = get_solr_response_for_doc_id
    if @document[:exemplary_image_ssi]
      filename = @document[:id].to_s + '_thumbnail'
      if @document[blacklight_config.flagged_field.to_sym]
        send_file File.join(Rails.root, 'app', 'assets', 'images', 'dc_image-icon.png'),
                  :filename => filename + '.png',
                  :type => :png,
                  :disposition => 'inline'
      else
        thumb_datastream_url = view_context.datastream_disseminator_url(@document[:exemplary_image_ssi], 'thumbnail300')
        response = Typhoeus::Request.get(thumb_datastream_url)
        if response.headers[/404 Not Found/]
          not_found
        else
          send_data response.body,
                    :filename => filename + '.jpg',
                    :type => :jpg,
                    :disposition => 'inline'
        end
      end
    else
      not_found
    end
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
