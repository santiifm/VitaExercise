class CreateClient < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :username, null: false
      t.timestamps
    end
  end
end
