class FollowsController < ApplicationController
	before_action :authenticate_user!
	def index 
		@follows = current_user.followees.order(:created_at.desc).entries
		puts "FOLLOWS *************************"
		awesome_print(@follows)
	end
	def post 
		@post = Post.find(params[:post_id])
		current_user.follow(@post)
		redirect_to follows_path
	end
	def unfollow_post
		@post = Post.find(params[:post_id])
		current_user.unfollow(@post)
		redirect_to follows_path
	end
	def task 
		@task = Task.find(params[:task_id])
		current_user.follow(@task)
		redirect_to follows_path
	end
	def unfollow_task
		@task = Task.find(params[:task_id])
		current_user.unfollow(@task)
		redirect_to follows_path
	end
end
