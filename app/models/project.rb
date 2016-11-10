class Project
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Autoinc
	include ActsAsFollower::Follower
  include ActsAsFollower::Followable
  field :project_id, type: Integer
  increments :project_id

	field :title, type: String
  field :deadline, type: DateTime
  field :started_at, type: DateTime
  field :progress, type: Integer, default: 0
  field :archive, type: Boolean
  field :description, type:String
	has_many :tasks, as: :taskable,dependent: :destroy
	belongs_to :creator, class_name:'User', inverse_of: :projects_created
	
	has_and_belongs_to_many :members, inverse_of: :projects, class_name:'User'
	
	has_many :posts, dependent: :destroy
  after_find :set_progress
  before_save :add_creator_to_members, if: :creator_id_changed?
	validates :title,  presence: true, length: {maximum: 200}	
	validates :progress, presence: true, numericality: { only_integer: true },
										 inclusion: {in: 0..100}
	validates_datetime :deadline, after: :started_at, if: :deadline_changed?
	validates_datetime :deadline
	validates_datetime :started_at
	validates :creator_id, presence: true
	acts_as_followable


	def add_creator_to_members
		unless self.members.include?(self.creator)
			self.members << self.creator
		end
	end
	def set_progress 
    addition = 0
    self.tasks.each do |task|
    	if task.progress
      	unless task.progress == 0
						addition += task.progress 
						self.progress = addition / self.tasks.count  
				end
			end
    end
	end
	def add_member user 
		if self.members.include?(user)
			raise Mongoid::Errors::Validations
		else
			self.add_to_set(member_ids: user.id)
			user.add_to_set(project_ids: self.id)
			user.save
		end
	end
end
