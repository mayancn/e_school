class Group
  include Mongoid::Document

  field :group_name, type: String
  field :group_type, type: String
  
  #Associations
  belongs_to :organization, optional: true
  has_and_belongs_to_many :users
  has_and_belongs_to_many :quizzes
  #Validations
  validates :group_name, uniqueness: { case_sensitive: false }
end
