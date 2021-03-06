class Book < ActiveRecord::Base
  attr_accessible :author, :synopsis, :title, :year, :copies
  has_and_belongs_to_many :users
  before_destroy { users.clear }

  validates :title, presence: true, uniqueness: { scope: :author }
  validates :author, presence: true
  validates :synopsis, length: { maximum: 150 }
  validates :copies, presence: true
end
