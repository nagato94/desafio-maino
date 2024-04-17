class ProcessFileJob < ApplicationJob
  queue_as :default

  def perform(file_blob_id)
    file_blob = ActiveStorage::Blob.find(file_blob_id)
    file_contents = file_blob.download
    file_contents.each_line do |line|
      title, body, tags = line.split('|').map(&:strip)
      post = Post.create(title: title, body: body, user: User.first)  # Ajuste conforme necessário
      tags.split(',').each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name.strip)
        post.tags << tag unless post.tags.include?(tag)
      end
    end
    file_blob.purge  # Opcional: remove o arquivo após processar
  end
end
