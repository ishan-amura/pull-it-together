class UsersController < ApplicationController
	before_action :authenticate_user!, only: [:show]
	#before_action :authorize_user!
	before_action :setup_user, only: [:show]

	def show
		@projects = current_user.projects.order(:deadline.asc)
		#@tasks = Task.where('user_id = ?',@user).where.not(status:'complete').order(:due_date)
		@tasks = @user.tasks.order(:due_date.asc)
	end

	private 
		def setup_user
			@user = User.find(params[:id])
		end
end
