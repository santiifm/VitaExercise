class AddUniqueIndexToclientsUsername < ActiveRecord::Migration[7.1]
  def change
    add_index :clients, :username, unique: true
  end
end
