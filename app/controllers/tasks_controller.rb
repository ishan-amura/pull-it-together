class TasksController < ApplicationController
	before_action :set_project ,only: [:edit,:update,:show,:new,:delete]
  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
  end

  def show
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    session[:project_id] = params[:project_id]
    @subtasks  = @task.tasks
    @addition_progress = 0
    @subtasks.each do |subtask|
       if subtask.progress == 0
          @task.progress = 0
        else
          @addition_progress = @addition_progress + subtask.progress 
          @task.progress = @addition_progress / @subtasks.count  
        end
     end      
     @task.save
  end

  def new
  	@task = @project.tasks.new()
  	@task[:started_at] = Time.now()
  end

  def create
  	@project = Project.find(params[:project_id])
  	@task = @project.tasks.new(task_params)
    @task.user = current_user
  	if @task.save!
  		redirect_to user_project_path(current_user,@project)
  	else
  		render 'new'
  	end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
  	@task = Task.find(params[:id])
  	if @task.update_attributes(update_params)
  		redirect_to project_task_path(params[:project_id],@task)
  	end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    if @task.destroy
      redirect_to project_tasks_path(@project)
    end
  end

  private
  	def set_project
  		@project= Project.find(params[:project_id])
  	end
  	def task_params
    	data = params.require(:task).permit(:title,:description,:due_date,:started_at,:priority)
  		due_date = data[:due_date] +" "+Time.now.strftime("%H:%M:%S %z")
      data.store(:due_date,due_date) 	
  		data
		end
		def update_params
			params.require(:task).permit(:title,:description,:user_id,:due_date,:priority,:status,:progress)
		end
end
