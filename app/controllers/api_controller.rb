
class ApiController < ActionController::Base
  include Blacklight::Configurable
  include Blacklight::TokenBasedUser
  #before_action :validate_pw, :except=>[:digital_stacks_login]

  copy_blacklight_config_from(CatalogController)

  def digital_stacks_create
    debug_user_logger = Logger.new('log/digital_stacks_create.log')
    debug_user_logger.level = Logger::DEBUG

    begin
      request_json = JSON.parse(request.body.read)
    rescue
      respond_to do |format|
        format.json { render json: {"result" => 'Invalid JSON', 'message' => 'Could not parse the JSON hash', 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
      end
    end

    if request_json.blank?
      respond_to do |format|
        format.json { render json: {"result" => 'Invalid JSON', 'message' => 'It seems there is no JSON content in your post?', 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
      end
    end

    if pw != request_json["password"]
      debug_user_logger.debug "Full Request on invalid password is: #{request_json.to_yaml}"
      respond_to do |format|
        format.json { render json: {"result" => 'Unauthorized', 'message' => 'Your password was incorrect', 'contact'=> 'sanderson@bpl.org'}.as_json, status: 401 }
      end
    end

    begin
      if request_json["barcode"]["type"] == 'mbln'
        barcode = request_json["barcode"]["value"]
        debug_user_logger.debug "Barcode is: #{barcode}"

        lookup = BplApi::Polaris.new
        lookup_response = lookup.get_user_data(barcode)

        if lookup_response.blank? || lookup_response.info[:valid_patron] == 'false'
          respond_to do |format|
            format.json { render json: {"result" => 'Invalid barcode', 'message' => "The library card barcode appears to be invalid", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
          end
        else
          @user = User.find_for_polaris_oauth(lookup_response)

          target_folder = @user.folders.where(:title=>request_json["name"])
          if target_folder.blank?
            target_folder = @user.folders.new
            target_folder.title = request_json["name"]
            target_folder.description = request_json["name"]
            target_folder.visibility = 'private'
            target_folder.save!
          else
            target_folder = target_folder.first
          end
          request_json["items"].each do |item_to_add|
            target_folder.folder_items.create!(:document_id => item_to_add) and target_folder.touch unless target_folder.has_folder_item(item_to_add)
          end

          respond_to do |format|
            format.json { render json: {"result" => 'added to account', 'message' => "Added items to folder #{request_json["name"]}", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 200 }
          end
        end

      elsif  request_json["barcode"]["type"] == 'temporary'
        user_details = {}
        user_details[:uid] = request_json["barcode"]["value"]
        user_details[:display_name] = request_json["barcode"]["value"]
        user_details[:provider] = 'digital_stacks_temporary'
        user_details[:email] = ''
        user_details[:password] = Devise.friendly_token[0,20]
        user_details[:first_name] = request_json["barcode"]["value"]
        user_details[:last_name] = ''

        @user = User.find_for_local_auth(OpenStruct.new(user_details))

        target_folder = @user.folders.where(:title=>request_json["name"])
        if target_folder.blank?
          target_folder = @user.folders.new
          target_folder.title = request_json["name"]
          target_folder.description = request_json["name"]
          target_folder.visibility = 'private'
          target_folder.save!
        else
          target_folder = target_folder.first
        end
        request_json["items"].each do |item_to_add|
          target_folder.folder_items.create!(:document_id => item_to_add) and target_folder.touch unless target_folder.has_folder_item(item_to_add)
        end

        respond_to do |format|
          format.json { render json: {"result" => 'added to account', 'message' => "Added items to folder #{request_json["name"]}", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 200 }
        end
      else
        respond_to do |format|
          format.json { render json: {"result" => 'Not implemented yet', 'message' => "Only mbln implemented thus far", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 404 }
        end
      end

    rescue => error
      respond_to do |format|
        format.json { render json: {"result" => 'Caught an error for ', 'message' => "#{error.message}.", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
      end
    end
  end


  def pw
    @pw ||= YAML.load_file(Rails.root.join('config', 'bpl_api.yml'))[Rails.env]["api_password"]
  end

  def digital_stacks_login
    current_or_guest_user.save! unless current_or_guest_user.persisted?
    #render html: "<b>You passed in login identifier: #{params[:id]}<b/>".html_safes
    @user = User.where(:provider => 'digital_stacks_temporary', :uid => params[:id]).first



    @user.folders.each do |folder|
      target_folder = current_or_guest_user.folders.where(:title=>folder.title)
      if target_folder.blank?
        target_folder = current_or_guest_user.folders.create({title: folder.title, description: folder.description, visibility: folder.visibility})
        target_folder.save! if current_user
      else
        target_folder = target_folder.first
      end
      folder.folder_items.each do |item_to_add|
        unless target_folder.has_folder_item(item_to_add.document_id)
          target_folder.folder_items.create(:document_id => item_to_add.document_id) and target_folder.touch
          #current_or_guest_user.bookmarks.create({ document_id: item_to_add.document_id, document_type: blacklight_config.document_model.to_s })
          target_folder.save! if current_user
        end
      end
    end

    if !current_user
      flash[:notice] = %Q[You are viewing your saved Digital Stacks items in a temporary session. To persist these inside of a full account, please click the <a href="#{new_user_session_path}" title="Sign Up Link">Sign Up / Log In</a> link.]
    end
    #current_or_guest_user.save!
    #raise token_or_current_or_guest_user.folders.to_yaml

    #sign_in_and_redirect @user, :event => :authentication
    #sign_in @user, :event => :authentication
    redirect_to '/folders'
  end

end