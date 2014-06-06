class AddCopiesToBooks < ActiveRecord::Migration
  def change
    add_column :books, :copies, :integer
  end
end
