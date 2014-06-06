class AddIndexToBooksUsersUserId < ActiveRecord::Migration
  def change
    add_index :books_users, :user_id
  end
end
