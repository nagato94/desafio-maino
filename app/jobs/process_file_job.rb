class ProcessFileJob < ApplicationJob
  queue_as :default

  def perform(file_content)
    file_content.each_line do |line|
      Post.create!(title: line.strip, body: "Generated from file upload")
      # Ou, para tags: Tag.find_or_create_by(name: line.strip)
    end
  end
end
