module SearchHistoryConstraintsHelper
  include Blacklight::SearchHistoryConstraintsHelperBehavior

  # making local copy of this method as the source code has bug
  # where nil and value-to-be-returned are switched in ternary syntax
  def render_search_to_s_q(params)
    return "".html_safe if params[:q].blank?

    label = (default_search_field && params[:search_field] == default_search_field[:key]) ?
        label_for_search_field(params[:search_field]) :
        nil

    render_search_to_s_element(label , params[:q] )
  end

end