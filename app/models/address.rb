class Address
  include Mongoid::Document

  field :country, type: String
  field :state, type: String
  field :city, type: String
  field :street, type: String
  field :locality, type: String
  field :landmark, type: String
  field :postal_code, type: String
  field :isd_code, type: String
  field :mobile, type: String
  
  #Associations
  belongs_to :organization, required: false
end
