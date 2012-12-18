module BlacklightHelper
  include Hydra::BlacklightHelperBehavior

  # add extra tools to show view -- folders, social sharing, etc.
  def render_show_doc_actions(document=@document, options={})
    wrapping_class = options.delete(:documentFunctions) || "documentFunctions"
    content = []
    # social media:
    content << render(:partial => 'catalog/add_this')
    content << render(:partial => 'catalog/bookmark_control', :locals => {:document=> document}.merge(options)) if has_user_authentication_provider? and current_or_guest_user
    content_tag("div", content.join("\n").html_safe, :class=>"documentFunctions")
  end

end