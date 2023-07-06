require 'roo'
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:invitable,
         :recoverable, :rememberable, :trackable, :validatable

  include Mongoid::Locker

  #Token Authenticatable
  acts_as_token_authenticatable

  attr_accessor :login
  
  ## Database authenticatable
  field :username,           type: String
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  
  ## Rememberable
  field :remember_created_at, type: Time
  
  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  
  ## Confirmable
  #  field :confirmation_token,   type: String
  #  field :confirmed_at,         type: Time
  #  field :confirmation_sent_at, type: Time
  #  field :unconfirmed_email,    type: String # Only if using reconfirmable
  
  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  #Custom
  field :name, type: String
  field :last_name, type: String, default: ""
  field :approved, type: Boolean, default: false
  field :approver_comment, type: String
  field :dob, type: Date
  #For simple token
  field :authentication_token
  
  field :role, type: String, default:"admin"
  
  #Invitable
  field :invitation_token, type: String
  field :invitation_created_at, type: Time
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer
  
  index( { invitation_token: 1 }, { background: true} )
  index( { invitation_by_id: 1 }, { background: true} )
  
  #Associations
  has_many :solve_questions
  has_many :results
  has_many :quizzes
  has_many :xlquizs
  has_and_belongs_to_many :groups
  belongs_to :evaluator, polymorphic: true, inverse_of: :evaluator, optional: true
  belongs_to :responder, polymorphic: true, inverse_of: :responder, optional: true
  belongs_to :organization, optional: true
  
  #field :locker_locked_at, type: Time
  #field :locker_locked_until, type: Time
  
  #locker locked_at_field: :locker_locked_at,
  #locked_until_field: :locker_locked_until
  
  ## Required
  # field :provider, type: String
  # field :uid,      type: String, default: ''
  
  ## Tokens
  # field :tokens, type: Hash, default: {}
  
  accepts_nested_attributes_for :organization
  # index({ uid: 1, provider: 1}, { name: 'uid_provider_index', unique: true, background: true })
  #validations
  validates_presence_of :name
  validates :username, uniqueness: { case_sensitive: false }, allow_nil: true
  #validates :email, uniqueness: { case_sensitive: false }
  #                  format: URI::MailTo::EMAIL_REGEXP
  
  def login
    @login || self.username || self.email
  end

  #Remove email from validation
  def email_required?
    false
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where('$or' => [ {:username => /^#{::Regexp.escape(login)}$/i}, {:email => /^#{::Regexp.escape(login)}$/i} ]).first
    else
      where(conditions).first
    end
  end 

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  #Accepts Xlquiz object
  def self.upload_users(xl_obj)
    groups=""
    xl = Roo::Spreadsheet.open(xl_obj.book.path, extension: :xlsx)
    sheet = xl.sheet(0)
    sheet.each(name: "First name", 
    last_name: "Last name", 
    dob: "Date of birth", 
    email: "Swalekhan Id / Email Id", 
    password: "Password", 
    password_confirmation: "Repeat password", 
    group: "Group", 
    role: "User Role"
    ) do |h|
      groups=h[:group]
      h.except!(:group)
      u=User.new(h)
      u.role = u.role.downcase
      if u.email.blank?
        u.username = User.create_username(u.name, u.last_name, u.dob) 
        u.password = u.username
        u.password_confirmation  = u.username
      elsif !!(u.email =~ Devise.email_regexp) == false
        u.username = u.email
        u.email = ""
      end
      u.approved=true
      u.organization_id = xl_obj.user.organization_id         
      u.save
      #Add user id to groups
      o_groups = Group.where(:group_name.in => groups.split(",")) if !groups.blank?
      if !o_groups.nil?
        o_groups.each do |g|
          g.user_ids.push(u.id)
          g.save
        end
      end
    end
  end

  def self.create_username(f_name, l_name, dob)
    f_name = f_name.strip
    l_name = l_name.strip
    dd = dob.to_s[dob.to_s.size-2, 2]
    user_name = f_name + l_name + dd
    mm = nil
    loop do
      user = User.where(username: user_name).first
      if user.nil?
        break
      elsif mm.nil?
        mm = dob.to_s[dob.to_s.size-5, 2]
        user_name = f_name + l_name + dd + mm
        user = User.where(username: user_name).first
      end
    end
    user_name.downcase
  end


end
