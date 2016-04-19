
class ApiController < ActionController::Base
  before_action :validate_pw, :except=>[:digital_stacks_login]

  def digital_stacks_create
    debug_user_logger = Logger.new('log/digital_stacks_create.log')
    debug_user_logger.level = Logger::DEBUG

    request_json = JSON.parse(request.body.read)
    begin
      if request_json["barcode"]["type"] == 'mbln'
        barcode = request_json["barcode"]["value"]
        debug_user_logger.debug "Barcode is: #{barcode}"

        lookup = BplApi::Polaris.new
        lookup_response = lookup.get_user_data(barcode)
        debug_user_logger.debug "Lookup response is: #{lookup_response.to_yaml}"
        if lookup_response.blank? || lookup_response.info[:valid_patron] == 'false'
          respond_to do |format|
            format.json { render json: {"result" => 'Invalid barcode', 'message' => "The library card barcode appears to be invalid", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
          end
        else
          @user = User.find_for_polaris_oauth(lookup_response)
          debug_user_logger.debug "User response is: #{@user.to_yaml}"


          target_folder = @user.folders.where(:title=>request_json["name"])
          if target_folder.blank?
            target_folder = @user.folders.new
            target_folder.title = request_json["name"]
            target_folder.description = request_json["name"]
            target_folder.visibility = 'private'
            debug_user_logger.debug "Target Folder User Is: #{target_folder.user.to_yaml}"
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

  def validate_pw
    debug_user_logger = Logger.new('log/digital_stacks_create.log')
    debug_user_logger.level = Logger::DEBUG
    debug_user_logger.debug "------------------------------------"

    request_json = nil
    begin
      request_json = JSON.parse(request.body.read)
    rescue
      respond_to do |format|
        format.json { render json: {"result" => 'Invalid JSON', 'message' => 'Could not parse the JSON hash', 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
      end
    end

    if pw != request_json["password"]
      debug_user_logger.debug "Full Request Content is: #{request_json.to_yaml}"
      respond_to do |format|
        format.json { render json: {"result" => 'Unauthorized', 'message' => 'Your password was incorrect', 'contact'=> 'sanderson@bpl.org'}.as_json, status: 401 }
      end
    end

  end

  def pw
    @pw ||= YAML.load_file(Rails.root.join('config', 'bpl_api.yml'))[Rails.env]["api_password"]
  end

  def digital_stacks_login
    render html: "<b>You passed in login identifier: #{params[:id]}<b/>".html_safe
  end

end