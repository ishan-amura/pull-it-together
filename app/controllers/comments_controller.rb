class CommentsController < ApplicationController
  before_action :authenticate_user!
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  def show
  end

  def new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
      	format.html { redirect_to([current_user,@post.project]) }
      	format.js { render 'task_comments/create'}
      end
    else
      render 'new'
    end 
  end

  def edit
  end

  def update
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.destroy  
      redirect_to project_post_path(@post.project,@post)
    end
  end

  private
   def comment_params
      params.require(:comment).permit(:body)
   end
end
