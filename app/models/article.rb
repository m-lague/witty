class Article < ApplicationRecord
  belongs_to :user
  has_many :upvotes, as: :upvotable
  has_and_belongs_to_many :tags

  include UpvotableConcern
end
