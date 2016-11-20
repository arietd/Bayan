class Post < ApplicationRecord
	validates :body, presence: true, length: { minimum: 20 }
	acts_as_taggable
end
