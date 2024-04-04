class Comment < ApplicationRecord
  belongs_to :expense
  has_many :replies, dependent: :destroy

	validates :content, presence: true
end
