class CreateUsers < RailsMigration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :active
      t.string :description

      t.timestamps
    end
  end
end
