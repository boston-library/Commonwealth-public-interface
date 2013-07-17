class FolderItemsController < CatalogController

  # give controller access to useful BL/Solr methods
  #include Blacklight::Configurable
  #include Blacklight::SolrHelper

  before_filter :verify_user

  def update
    create
  end

  def create
    @response, @document = get_solr_response_for_doc_id(params[:id])
    if params[:folder_items]
      @folder_items = params[:folder_items]
    else
      @folder_items = [{ :document_id => params[:id], :folder_id => params[:folder_id] }]
    end

    success = @folder_items.all? do |f_item|
      current_user.folders.find(f_item[:folder_id]).folder_items.create!(:document_id => f_item[:document_id]) unless current_user.existing_folder_item_for(f_item[:document_id])
    end

    unless request.xhr?
      flash[:notice] = t('blacklight.folder_items.add.success')
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end

  end


  # Beware, :id is the Solr document_id, not the actual Bookmark id.
  # idempotent, as DELETE is supposed to be.
  def destroy
    @response, @document = get_solr_response_for_doc_id(params[:id])
    folder_item = current_user.existing_folder_item_for(params[:id])

    # success = (!folder_item) || FolderItem.find(folder_item).destroy

    Bpluser::FolderItem.find(folder_item).destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end

  end

  def clear
    @folder = Bpluser::Folder.find(params[:id])
    if current_user.folders.find(@folder).folder_items.clear
      flash[:notice] = I18n.t('blacklight.folder_items.clear.success')
    else
      flash[:error] = I18n.t('blacklight.folder_items.clear.failure')
    end
    redirect_to :controller => "folders", :action => "show", :id => @folder
  end

  def delete_selected
    @folder = Bpluser::Folder.find(params[:id])
    if params[:selected]
      if @folder.folder_items.where(:document_id => params[:selected]).delete_all
        flash[:notice] = I18n.t('blacklight.folders.update_items.remove.success')
      else
        flash[:error] = I18n.t('blacklight.folders.update_items.remove.failure')
      end
      redirect_to :controller => "folders", :action => "show", :id => @folder
    else
      redirect_to :back
      flash[:error] = I18n.t('blacklight.folders.update_items.remove.no_items')
    end
  end

  #def item_actions
  #  @folder = Folder.find(params[:id])
  #  if params[:selected]
  #    sort = params[:sort] ? params[:sort] : ""
  #    per_page = params[:per_page] ? params[:per_page] : ""
  #    view = params[:view] ? params[:view] : ""
  #    items = params[:selected]
  #
  #   case params[:commit]
  #          when t('blacklight.tools.email')
  #            redirect_to email_catalog_path(:id => items)
  #          when t('blacklight.tools.cite')
  #           redirect_to citation_catalog_path(:id => items)
  #          when t('blacklight.tools.remove')
  #            if @folder.folder_items.where(:document_id => items).delete_all
  #              flash[:notice] = I18n.t('blacklight.folders.update_items.remove.success')
  #            else
  #              flash[:error] = I18n.t('blacklight.folders.update_items.remove.failure')
  #            end
  #            redirect_to folder_path(:id => @folder,
  #                                    :sort => sort,
  #                                    :per_page => per_page,
  #                                    :view => view)
  #    end
  #  else
  #    redirect_to :back
  #    flash[:error] = I18n.t('blacklight.folders.update_items.remove.no_items')
  #  end
  #end

  protected
  def verify_user
    flash[:notice] = I18n.t('blacklight.folders.need_login') and raise Blacklight::Exceptions::AccessDenied unless current_user
  end

end
