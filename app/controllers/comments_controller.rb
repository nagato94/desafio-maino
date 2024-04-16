class CommentsController < ApplicationController
  before_action :set_post
  skip_before_action :authenticate_user!, only: [:create]  # Adiciona esta linha se estiver usando Devise

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user if user_signed_in?
    if @comment.save
      redirect_to root_path, notice: 'Comment was successfully added.'
    else
      redirect_to post_path(@post), alert: 'Error adding comment. Please ensure your comment is not empty.'
    end
  end



  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
