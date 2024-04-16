class CommentsController < ApplicationController
  before_action :set_post
  skip_before_action :authenticate_user!, only: [:create]  # Adiciona esta linha se estiver usando Devise

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to root_path, notice: t('posts.comments.add_success')
    else
      redirect_to post_path(@post), alert: t('posts.comments.add_fail')
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
