class Post < ApplicationRecord
	validates :body, presence: true, length: { minimum: 20 }
	acts_as_taggable
	acts_as_votable
	ActsAsTaggableOn.remove_unused_tags = true

	# not used 
	# ment for search 
	def self.search(search)
	  if search
	    where('body LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end
end
