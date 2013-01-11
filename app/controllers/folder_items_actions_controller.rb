# use to share folder item actions (email, cite, delete) between folders and bookmarks
class FolderItemsActionsController < ApplicationController

  def folder_item_actions
    @folder = Folder.find(params[:id]) if params[:origin] == "folders"
    @user = current_or_guest_user
    if params[:selected]
      sort = params[:sort] ? params[:sort] : ""
      per_page = params[:per_page] ? params[:per_page] : ""
      view = params[:view] ? params[:view] : ""
      items = params[:selected]

      case params[:commit]
        when t('blacklight.tools.email')
          redirect_to email_catalog_path(:id => items)
        when t('blacklight.tools.cite')
          redirect_to citation_catalog_path(:id => items)
        when t('blacklight.tools.remove')
          if params[:origin] == "folders"
            if @folder.folder_items.where(:document_id => items).delete_all
              flash[:notice] = I18n.t('blacklight.folders.update_items.remove.success')
            else
              flash[:error] = I18n.t('blacklight.folders.update_items.remove.failure')
            end
            redirect_to folder_path(:id => @folder,
                                    :sort => sort,
                                    :per_page => per_page,
                                    :view => view)
          else
            if current_or_guest_user.bookmarks.where(:document_id => items).delete_all
              flash[:notice] = I18n.t('blacklight.folders.update_items.remove.success')
            else
              flash[:error] = I18n.t('blacklight.folders.update_items.remove.failure')
            end
            redirect_to bookmarks_path(:sort => sort,
                                      :per_page => per_page,
                                      :view => view)
          end
      end

    else
      redirect_to :back
      flash[:error] = I18n.t('blacklight.folders.update_items.remove.no_items')
    end

  end

end