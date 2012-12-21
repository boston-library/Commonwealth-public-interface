class FoldersController < ApplicationController

  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)

  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url
    catalog_index_url
  end
  helper_method :search_action_url

  before_filter :verify_user

  def index
    @folders = current_user.folders
    if @folders.empty?
      flash[:notice] = t('blacklight.folders.no_folders')
    end
  end

  def show
    @folder = Folder.find(params[:id])
    @folder_items = @folder.folder_items
    folder_items_ids = @folder_items.collect { |f_item| f_item.document_id.to_s }

    @response, @document_list = get_solr_response_for_field_values(SolrDocument.unique_key, folder_items_ids)
  end

  def new
    @folder = current_user.folders.new
  end

  def create
    @folder = current_user.folders.build(params[:folder])
    if @folder.save
      flash[:notice] = "Folder created."
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @folder = Folder.find(params[:id])
  end

  def update
    @folder = Folder.find(params[:id])
    if @folder.update_attributes(params[:folder])
      flash[:notice] = "Folder updated."
      redirect_to @folder
    else
      render :action => "edit"
    end
  end

  def destroy
    Folder.find(params[:id]).destroy
    flash[:notice] = t('blacklight.folders.delete.success')
    redirect_to :action => "index"
  end

  protected
  def verify_user
    flash[:notice] = I18n.t('blacklight.folders.need_login') and raise Blacklight::Exceptions::AccessDenied unless current_user
  end

end
