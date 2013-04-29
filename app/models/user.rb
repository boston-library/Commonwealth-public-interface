class User < ActiveRecord::Base
# Connects this user object to Hydra behaviors. 
 include Hydra::User
# Connects this user object to Blacklights Bookmarks. 
 include Blacklight::User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #Devise.add_module(:ldap_hydra_authenticatable,
  #                  :route => :session,
  #                  :strategy => true,
  #                  :controller => :sessions,
  #                  :model => 'devise/models/ldap_hydra_authenticatable')

  #devise :ldap_hydra_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account. 

  def to_s
    self.email
  end

  #def name
  #  return self.display_name.titleize || self.username rescue self.username
  #end

  #def user_key
  #  send(Devise.authentication_keys.first)
  #end

  #def groups
    #Hydra::LDAP.groups_for_user(username + ",dc=psu,dc=edu")
    #['archivist', 'admin_policy_object_editor']

  #  Hydra::LDAP.groups_for_user(Net::LDAP::Filter.eq('samaccountname', self.username), ['memberOf']) { |result| result.first[:memberOf].select{ |y| y.starts_with? 'CN=' }.map{ |x| x.sub(/^CN=/, '').sub(/,OU=Private Groups,DC=private,DC=bpl,DC=org/, '').sub(/,OU=Distribution Lists/, '').sub(/,OU=Security Groups/, '') } } rescue []
  #end

  #def populate_attributes

  #end

  #def default_user_groups
    # # everyone is automatically a member of the group 'public'
    #['public', 'test']
  #end

  has_many :folders, :dependent => :destroy

  def existing_folder_item_for (document_id)
    self.folders.find do |fldr|
      fldr.folder_items.find do |fldr_itm|
        return fldr_itm if fldr_itm.document_id == document_id
      end
    end
  end

end
