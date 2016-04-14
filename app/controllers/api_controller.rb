
class ApiController < ActionController::Base
  before_action :validate_pw, :except=>[:digital_stacks_login]

  def digital_stacks_create
    request = JSON.parse(request.body.read)
    begin
      if request["barcode"]["type"] == 'mbln'
        barcode = request["barcode"]["value"]

        lookup = BplApi::Polaris.new
        lookup_response = lookup.get_user_data(barcode)
        if lookup_response.blank? || lookup_response.info[:valid_patron] == 'false'
          respond_to do |format|
            format.json { render json: {"result" => 'Invalid barcode', 'message' => "The library card barcode appears to be invalid", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
          end
        else
          @user = User.find_for_polaris_oauth(lookup_response)


          target_folder = @user.folders.where(:title=>request["name"])
          if target_folder.blank?
            target_folder = @user.folders.new
            target_folder.title = request["name"][0..39]
            target_folder.description = request["name"]
            target_folder.visibility = 'private'
            target_folder.save!
          else
            target_folder = target_folder.first
          end
          request["items"].each do |item_to_add|
            target_folder.folder_items.create!(:document_id => item_to_add) and target_folder.touch unless target_folder.has_folder_item(item_to_add)
          end

          respond_to do |format|
            format.json { render json: {"result" => 'added to account', 'message' => "Added items to folder #{request["name"]}", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 200 }
          end
        end

      else

        respond_to do |format|
          format.json { render json: {"result" => 'Not implemented yet', 'message' => "Only mbln implemented thus far", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 404 }
        end
      end

    rescue => error
      respond_to do |format|
        format.json { render json: {"result" => 'Caught an error', 'message' => "#{error.message}", 'contact'=> 'sanderson@bpl.org'}.as_json, status: 500 }
      end
    end
  end

  def validate_pw
    if pw != request["password"]
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