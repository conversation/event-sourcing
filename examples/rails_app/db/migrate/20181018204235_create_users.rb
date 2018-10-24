class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :active
      t.string :description
      t.datetime :deleted_at, default: nil

      t.timestamps
    end
  end
end
