# frozen_string_literal: true

module DigitalStacksApi
  class Polaris
    FIELD_MAPPINGS = {
      'barcode' => 'Barcode',
      'valid_patron' => 'ValidPatron',
      'patron_id' => 'PatronID',
      'assigned_branch_id' => 'AssignedBranchID',
      'assigned_branch_name' => 'AssignedBranchName',
      'first_name' => 'NameFirst',
      'last_name' => 'NameLast',
      'middle_name' => 'NameMiddle',
      'phone_number' => 'PhoneNumber',
      'email' => 'EmailAddress'
    }.freeze

    def initialize
    end

    def secure_uri
      @secure_uri ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['secure_uri']
    end

    def public_uri
      @public_uri ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['public_uri']
    end

    def domain
      @domain ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['domain']
    end

    def username
      @username ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['username']
    end

    def password
      @password ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['password']
    end

    def access_id
      @access_id ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['access_id']
    end

    def access_key
      @access_key ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'digital_stacks_api.yml'))).result, aliases: true)[Rails.env]['access_key']
    end

    def http_date
      # Minus 5 seconds due to needing to be behind current time
      (Time.now.in_time_zone('GMT') - 5).strftime('%a, %d %b %Y %H:%M:%S %Z')
    end

    def auth_hash
      if @auth_hash.blank? || Time.zone.parse(@auth_hash[:expiration]) <= Time.now.in_time_zone('EST') || @auth_hash[:force_reset]
        url = "#{secure_uri}authenticator/staff"
        document = %(<AuthenticationData><Domain>#{domain}</Domain><Username>#{username}</Username><Password>#{password}</Password></AuthenticationData>)

        static_date = http_date
        concated_string = 'POST' + url + static_date
        sha1_sig = Base64.strict_encode64(OpenSSL::HMAC.digest('sha1',
                                                               access_key,
                                                               concated_string).to_s)
        xml_response = RestClient.post(url,
                                       document,
                                       { 'PolarisDate' => static_date,
                                         'Authorization' => "PWS #{access_id}:#{sha1_sig}",
                                         'Content-Type' => 'text/xml' })
        access_response = Hash.from_xml xml_response

        @auth_hash = {}
        @auth_hash[:token] = access_response['AuthenticationResult']['AccessToken']
        @auth_hash[:secret] = access_response['AuthenticationResult']['AccessSecret']
        @auth_hash[:expiration] = access_response['AuthenticationResult']['AuthExpDate'].gsub(/T.+/, '')
        @auth_hash[:force_reset] = false
      end
      @auth_hash
    end

    def get_user_data(barcode)
      # url = "#{base_uri}#{auth_hash[:token]}/synch/bibs/MARCxml?bibids=#{bibID}"
      # access_response = make_request(url)
      url = "#{public_uri}patron/#{barcode}"
      authorization_response = make_request(url)

      url = "#{public_uri}patron/#{barcode}/basicdata"
      details_response = make_request(url)

      # Add some of the basic details to a single hash, using the authorization as the base.
      %w(NameFirst NameLast NameMiddle PhoneNumber EmailAddress).each do |v|
        authorization_response['PatronValidateResult'][v] = details_response['PatronBasicDataGetResult']['PatronBasicData'][v]
      end

      user_info = map_user_works(FIELD_MAPPINGS, authorization_response['PatronValidateResult'])
      final_response = {}
      final_response[:provider] = 'polaris'
      final_response[:uid] = barcode
      final_response[:info] = user_info
      final_response[:extra] = { raw_info: authorization_response }
      OpenStruct.new(final_response)
    end

    def map_user_works(mapper, object)
      user = {}
      mapper.each do |key, value|
        case value
        when String
          # user[key] = object[value.downcase.to_sym].first if object[value.downcase.to_sym]
          user[key.to_sym] = object[value] if object[value]
        when Array
          # value.each { |v| (user[key] = object[v.downcase.to_sym].first; break;) if object[v.downcase.to_sym] }
          value.each { |v| (user[key] = object[v.downcase.to_sym]; break;) if object[v.downcase.to_sym] }
        when Hash
          value.map do |key1, value1|
            pattern = key1.dup
            value1.each_with_index do |v, i|
              # part = ''; v.collect(&:downcase).collect(&:to_sym).each { |v1| (part = object[v1].first; break;) if object[v1] }
              part = ''; v.collect(&:downcase).collect(&:to_sym).each { |v1| (part = object[v1]; break;) if object[v1] }
              pattern.gsub!("%#{i}", part || '')
            end
            user[key] = pattern
          end
        end
      end
      user
    end

    def make_request url
      static_auth_hash = auth_hash
      static_date = http_date
      concated_string = 'GET' + url + static_date + static_auth_hash[:secret]
      sha1_sig = Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', access_key, concated_string).to_s)
      xml_response = RestClient.get(url,
                                    { 'Date' => static_date,
                                      'Authorization' => "PWS #{access_id}:#{sha1_sig}",
                                      'Content-Type' => 'text/xml',
                                      'X-PAPI-AccessToken' => static_auth_hash[:token] })
      Hash.from_xml xml_response
    end
  end
end
