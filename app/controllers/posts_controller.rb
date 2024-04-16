class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
  end

  def show
    # @post é definido no set_post
    @comments = @post.comments.all
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: t('posts.create.success')
    else
      render :new, status: :unprocessable_entity, alert: t('posts.create.fail')
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: t('posts.update.success')
    else
      render :edit, alert: t('posts.update.fail')
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to root_path, notice: t('posts.delete.success')
    else
      redirect_to root_path, alert: t('posts.delete.unauthorized')
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
