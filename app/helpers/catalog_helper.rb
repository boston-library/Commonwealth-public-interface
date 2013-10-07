module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def extra_body_classes
    @extra_body_classes ||= ['blacklight-' + controller.controller_name, 'blacklight-' + [controller.controller_name, controller.action_name].join('-')]
    # if this is the home page
    if !has_search_parameters? && controller.controller_name == 'catalog' && controller.action_name =='index'
      @extra_body_classes.push('blacklight-home')
    else
      @extra_body_classes
    end
  end

  #def should_autofocus_on_search_box?
  #  controller.is_a? Blacklight::Catalog
  #end

  # might need this ?
  # def simpleimage_file_pid (document)
  #   return Bplmodels::Image.find(document[:id]).image_files.first.pid
  # end

end