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
    @post = Post.find(params[:id])
    @comments = @post.comments.all
  end

  def download
    @post = Post.find(params[:id])
    if @post.file.attached?
      send_data @post.file.download, filename: @post.file.filename.to_s, disposition: 'attachment'
    else
      redirect_to @post, alert: 'No file attached to this post.'
    end
  end


  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    # Anexa o arquivo ao post se um arquivo foi enviado
    @post.file.attach(params[:post][:file]) if params[:post][:file].present?

    # Processa as tags fornecidas
    process_tags(@post, params[:post][:new_tags]) if params[:post][:new_tags].present?

    # Verifica se o arquivo foi anexado e é um arquivo de texto; caso contrário, salva sem processar o arquivo
    if @post.file.attached? && file_is_text?(@post.file)
      ProcessFileJob.perform_later(@post.file.blob.id)  # Enfileira o job para processar o arquivo
    end

    if @post.save
      # Se o arquivo foi enviado e é válido, mostra a mensagem de processamento
      if @post.file.attached? && file_is_text?(@post.file)
        redirect_to posts_path, notice: 'Post creation initiated. File is being processed in the background.'
      else
        redirect_to posts_path, notice: 'Post was successfully created.'
      end
    else
      # Em caso de falha ao salvar, renderiza a view 'new' novamente
      render :new, alert: 'Failed to save post.', status: :unprocessable_entity
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
    # Retorna cedo se tag_string for nil ou vazia, evitando erros quando chamando `split`
    return if tag_string.blank?

    tag_names = tag_string.split(',').map(&:strip).uniq
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name)
      post.tags << tag unless post.tags.include?(tag)
    end
  end


  def file_is_text?(file)
    file.content_type == 'text/plain'
  end


  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :file, :new_tags, tag_ids: [])
  end
end
