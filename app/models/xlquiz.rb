class Xlquiz
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :book,
  path: ":rails_root/public/system/xlquiz/:id/:filename",
  url: "/system/xlquiz/:id/:filename"
  #Validations
  validates_attachment_content_type :book, :content_type => ["application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]
  #Associations
  belongs_to :user
end
