class Section
  include Mongoid::Document

  field :name, type: String
  #Associations
  has_many :questions
  belongs_to :quiz
end
