class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc
  field :notification_id, type: Integer
  increments :notification_id

  field :subject, type: String
  field :body, type: String
  field :resource_id, type: Integer
  field :category, type: String
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  validates_presence_of :recipient_id, :resource_id
end
