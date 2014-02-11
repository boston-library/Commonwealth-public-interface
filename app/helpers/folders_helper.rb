module FoldersHelper

  def folder_belongs_to_user
    this_user = current_or_guest_user
    if this_user.folders.include? @folder
      true
    else
      false
    end
  end

end
