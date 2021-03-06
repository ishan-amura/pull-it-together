class ProjectUsersController < ApplicationController
    before_action :authenticate_user!
  def new
  	@project = Project.find(params[:id])
  	@users = User.all - @project.members
  end

  def create
  	@project_user = ProjectUser.new()
  	@project_user.project_id = params[:id]
  	@project_user.user_id = params[:user_id]
  	begin 
  		@project_user.save!
  		redirect_to user_project_path(current_user,params[:id])
  	rescue Exception => e
  		if e.message.match('Validation failed')
  			flash[:notice] = "User is already a part of the project"
  		end
  		redirect_to new_project_user_path(params[:id])
  	end
  end
end
