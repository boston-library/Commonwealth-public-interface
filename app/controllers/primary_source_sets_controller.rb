# frozen_string_literal: true

class PrimarySourceSetsController < CatalogController
  include Blacklight::Configurable

  before_action :set_nav_active
  helper_method :search_action_url

  def index
    @set = PrimarySourceSet.new('index')
  end

  def show
    @set = PrimarySourceSet.new(params[:id])
    raise ActionController::RoutingError.new('Not Found') if @set.blank?

    @items = @set.item_documents
    @collections = @set.collection_documents
    render :index if params[:id] == 'culture'
  end

  protected

  # Blacklight uses #search_action_url to figure out the right URL for the global search box
  def search_action_url options = {}
    search_catalog_url(options.except(:controller, :action))
  end

  private

  def set_nav_active
    @nav_li_active = 'for_educators'
  end
end
