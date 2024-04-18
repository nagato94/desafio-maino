class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
def index
  if params[:tag].present?
    @posts = Post.joins(:tags)
                 .where(tags: { name: params[:tag] })
                 .distinct
                 .includes(:tags)  # Garantir que as tags sejam pré-carregadas
                 .order(created_at: :desc)
                 .page(params[:page]).per(3)
  else
    @posts = Post.includes(:tags)  # Pré-carregar tags mesmo sem filtro
                 .order(created_at: :desc)
                 .page(params[:page]).per(3)
  end
end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.all
    if @post.file.attached?
      send_data @post.file.download, filename: @post.file.filename, disposition: 'attachment'
    end
  end


  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    # Verifica se um arquivo foi enviado e, em caso afirmativo, se é um arquivo de texto
    if params[:post][:file].present?
      if file_is_text?(params[:post][:file])
        @post.body = params[:post][:file].read  # Salva o conteúdo do arquivo no campo 'body' do post
      else
        flash[:alert] = 'Please select a text file (.txt).'
        render :new
        return  # Interrompe a execução se o arquivo não é de texto
      end
    end

    # Tentar salvar o post, independentemente de ter ou não um arquivo
    if @post.save
      process_tags(@post, params[:post][:new_tags]) if params[:post][:new_tags].present?
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit

  end

  def update
    if @post.update(post_params)
      process_tags(@post, params[:post][:new_tags]) if params[:post][:new_tags].present?
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

  def file_is_text?(file)
    file.present? && file.respond_to?(:read) && file.content_type == 'text/plain'
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :new_tags, tag_ids: [], file: [])
  end
end
