class Post < ApplicationRecord
	validates :body, presence: true, length: { minimum: 20 }
	acts_as_taggable
	ActsAsTaggableOn.remove_unused_tags = true
end
