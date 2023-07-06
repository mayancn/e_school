class Organization
  include Mongoid::Document

  field :name, type: String, default: ""

  #Associations
  has_many :groups
  has_many :users
  has_many :quizzes

end
