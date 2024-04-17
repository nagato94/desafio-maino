class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where(tags: { name: params[:tag] }).distinct.order(created_at: :desc).page(params[:page]).per(3)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
    end
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
    process_tags(@post, params[:post][:new_tags])
    redirect_to @post, notice: t('posts.create.success')
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
  end

  def update
    if @post.update(post_params)
      process_tags(@post, params[:post][:new_tags])
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
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

  def process_tags(post, tag_string)
    tag_names = tag_string.split(',').map(&:strip).uniq
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name)
      post.tags << tag unless post.tags.include?(tag)
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, tag_ids: [], new_tags: [])
  end
end
