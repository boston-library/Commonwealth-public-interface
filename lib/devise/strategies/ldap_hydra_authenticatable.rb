# Default strategy for signing in a user, based on his email and password in the database.
module Devise
  module Strategies
    class LdapHydraAuthenticatable < ::Devise::Strategies::Authenticatable
      DEFAULT_LDAP_ARGS = { :host => 'glstpridc003.private.bpl.org', :port => 389, :base => 'dc=private,dc=bpl,dc=org' }
      #def valid?
      #params[:user][:username].present? and  params[:user][:password].present?
      #puts params[:login]
      #end
      def authenticate!

        if params[:user][:username].present? and  params[:user][:password].present?
          #ldap_conn = Hydra::LDAP.connection()
          username = params[:user][:username]
          qualified_username = "BPLPRIVATE\\#{username}"
          puts qualified_username
          ldap_conn =  Net::LDAP.new( DEFAULT_LDAP_ARGS.merge({ :auth => {:method => :simple, :username => qualified_username, :password => params[:user][:password]} }) )
          if ldap_conn.bind()
            ldap_return = ldap_conn.search( { :filter => Net::LDAP::Filter.eq('samaccountname',params[:user][:username]) } ).flatten.first
          else
            fail!
          end
          #u = User.find_or_create_by_username(request.headers["username"])
          firstname = ldap_return.givenname[0].to_s
          lastname = ldap_return.sn[0].to_s
          displayname = ldap_return.displayname[0].to_s
          username = ldap_return.sAMAccountName[0].to_s
          email = ldap_return.mail[0].to_s

          #if @user = User.find_by_username(username)
          #sign_in_and_redirect @user
          #else
          #@user = User.create(:firstname => firstname,
          #:lastname => lastname,
          #:displayname => displayname,
          #:username => username,
          #:email => email)
          #sign_in_and_redirect @user


          #end
          u = User.find_by_username(username)
          if u.nil?
            u = User.create(:username => username, :email => email)
          end
          success!(u)
        else
          fail!
        end
      end
    end
  end
end

Warden::Strategies.add(:ldap_hydra_authenticatable, Devise::Strategies::LdapHydraAuthenticatable)