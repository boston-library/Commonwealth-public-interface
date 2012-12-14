module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior
=begin
  # from BL 3.7
  # given a doc and action_name, this method attempts to render a partial template
  # based on the value of doc[:format]
  # if this value is blank (nil/empty) the "default" is used
  # if the partial is not found, the "default" partial is rendered instead
  def render_document_partial(doc, action_name, locals = {})
    format = document_partial_name(doc)

    document_partial_path_templates.each do |str|
      # XXX rather than handling this logic through exceptions, maybe there's a Rails internals method
      # for determining if a partial template exists..
      begin
        return render :partial => (str % [action_name, format]), :locals=>locals.merge({:document=>doc})
      rescue ActionView::MissingTemplate
        nil
      end
    end

    return ''
  end

  # a list of document partial templates to try to render for #render_document_partial
  #
  # (NOTE: I suspect #document_partial_name, #render_document_partial and #document_partial_path_templates
  # should be more succinctly refactored in the future)
  def document_partial_path_templates
    # first, the legacy template names for backwards compatbility
    # followed by the new, inheritable style
    # finally, a controller-specific path for non-catalog subclasses
    @partial_path_templates ||= ["catalog/_%s_partials/%s", "catalog/_%s_partials/default", "%s_%s", "%s_default", "catalog/%s_%s", "catalog/%s_default"]
  end
=end

end