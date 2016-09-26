class Task < ActiveRecord::Base
  belongs_to :taskable, polymorphic: true
  has_many :tasks, as: :taskable
  belongs_to :user
  has_many :comments
  has_many :labels, as: :labelable
  has_many :follows, as: :followable

  validates :taskable_type , presence: true, inclusion: { within: %w(Project Task) }
  validates_datetime :due_date, after: :started_at 
  validates :title,  presence: true, length: {maximum: 200}
  validates :priority, presence: true,inclusion: {in: %w(low normal high ASAP)}
  validates :status, presence: true,inclusion: { in: %w(finished active inactive none) }
  validates :progress, presence: true ,
                 numericality: { only_integer: true }, length: {maximum: 3}
  
end
