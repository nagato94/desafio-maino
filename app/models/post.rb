class Post < ApplicationRecord
  attr_accessor :new_tags
  has_one_attached :file
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  validates :title, presence: true
  validates :body, presence: true
  validates :new_tags, presence: true, if: -> { new_tags.present? }
end
