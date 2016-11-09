class Task
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Autoinc
	include ActsAsFollower::Follower
  include ActsAsFollower::Followable
  field :task_id,type: Integer
  increments :task_id
  
  field :title, type: String
  field :priority, type: String, default:->{"normal"}
  field :status, type: String, default:->{"none"}
  field :progress, type: Integer,default:->{0}
  field :description, type: String
  field :started_at, type: DateTime
  field :due_date, type: DateTime

	belongs_to :taskable, polymorphic: true
	has_many :tasks, as: :taskable, dependent: :destroy
	belongs_to :user
	has_many :comments, as: :commentable
	has_many :labels, as: :labelable

	after_save :set_user_as_follower, if: :user_id_changed?
	after_create :set_project_creator_as_follower
	after_find :set_progress
	after_find :set_progess_on_status_change
	validates :taskable_type , presence: true, inclusion: { within: %w(Project Task) }
	validates_datetime :due_date, after: :started_at 
	validates :title,  presence: true, length: {maximum: 200}
	validates :priority, presence: true,inclusion: {in: %w(low normal high ASAP)}
	validates :status, presence: true, inclusion: { in: %w(complete active inactive none) }
	validates :progress, presence: true ,
	numericality: { only_integer: true }, length: {maximum: 3}
	validates :user_id, presence: true

	acts_as_followable

	def parent_project
		return self.taskable if self.taskable.class.name == 'Project'
		self.taskable.parent_project
	end
	def due_when
		if self.due_date.to_date.today?
			"Today"
		elsif self.due_date.to_date == Date.tomorrow
			"Tomorrow"
		elsif self.due_date.to_date == (Date.tomorrow + 1.days)
			"Day after tomorrow"
		else
			self.due_date.to_date
		end	
	end
	private
	def set_user_as_follower
		unless self.user.following?(self)
			self.user.follow(self)
		end
	end
	def set_project_creator_as_follower
		if self.taskable_type == 'Project'
			project = Project.find(self.taskable_id)
			unless project.creator.following?(self)
				project.creator.follow(self)
			end
		end
	end
	def set_progress
		if self.tasks
			subtasks  = self.tasks
			addition = 0
			subtasks.each do |subtask|
				unless subtask.progress == 0
					addition += subtask.progress 
					self.progress = addition / subtasks.count  
				end
			end
		end 
	end
	def set_progess_on_status_change
		if self.status == 'complete'
			self.progress = 100 
		end
	end
	
end
