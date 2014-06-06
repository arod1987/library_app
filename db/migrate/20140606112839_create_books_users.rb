class CreateBooksUsers < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
    create_table :books_users, id: false do |t|
      t.integer :book_id
      t.integer :user_id
    end
  end
end
