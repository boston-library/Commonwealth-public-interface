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

  def should_autofocus_on_search_box?
    (controller.is_a? Blacklight::Catalog and
        action_name == "index" and
        params[:q].to_s.empty? and
        params[:f].to_s.empty?) or
    (controller.is_a? PagesController and action_name == 'home')
  end

end