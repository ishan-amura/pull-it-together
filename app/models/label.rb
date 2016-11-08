class Label
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :color, type: String

  belongs_to :labelable, polymorphic: true
  validates :name, presence: true
  validates :color, presence: true
end
