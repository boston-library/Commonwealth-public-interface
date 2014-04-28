module BlacklightHelper
  include Hydra::BlacklightHelperBehavior

  # add extra tools to show view -- folders, social sharing, etc.
  def render_show_doc_actions(document=@document, options={})
    wrapping_class = options.delete(:documentFunctions) || options.delete(:wrapping_class) || "documentFunctions"
    content = []
    #content << render(:partial => 'catalog/bookmark_control', :locals => {:document=> document}.merge(options)) if render_bookmarks_control?

    # social media:
    content << render(:partial => 'catalog/add_this')
    if has_user_authentication_provider? and current_or_guest_user
      content << render(:partial => 'catalog/folder_item_control', :locals => {:document => document})
    end
    content_tag("div", content.join("\n").html_safe, :class=> wrapping_class)
  end

  def item_actions
    @folder = Folder.find(params[:id])
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
          if @folder.folder_items.where(:document_id => items).delete_all
            flash[:notice] = I18n.t('blacklight.folders.update_items.remove.success')
          else
            flash[:error] = I18n.t('blacklight.folders.update_items.remove.failure')
          end
          redirect_to folder_path(:id => @folder,
                                  :sort => sort,
                                  :per_page => per_page,
                                  :view => view)
      end
    else
      redirect_to :back
      flash[:error] = I18n.t('blacklight.folders.update_items.remove.no_items')
    end
  end

end