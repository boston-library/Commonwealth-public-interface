module RenderConstraintsHelper
  include Blacklight::RenderConstraintsHelperBehavior
=begin
  # LOCAL OVERRIDE
  # add method to show constraint for 'more like this' search
  ##
  # Render the actual constraints, not including header or footer
  # info.
  #
  # @param [Hash] query parameters
  # @return [String]
  def render_constraints(localized_params = params)
    puts "CPI RENDERCONSTRAINTS"
    render_mlt_query(localized_params) + render_constraints_query(localized_params) + render_constraints_filters(localized_params)
  end
=end
  ##
  # Render the 'more like this' query constraints
  #
  # @param [Hash] query parameters
  # @return [String]
  def render_mlt_query(localized_params = params)
    # So simple don't need a view template, we can just do it here.
    scope = localized_params.delete(:route_set) || self
    return ''.html_safe if localized_params[:mlt_id].blank?

    render_constraint_element(t('blacklight.more_like_this.constraint_label'),
                              localized_params[:mlt_id],
                              :classes => ['mlt'],
                              :remove => scope.url_for(localized_params.merge(:mlt_id=>nil, :qt=>nil, :action=>'index')))
  end


end