class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.references :user, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.string :name
      t.string :power
      t.string :monster_type

      t.timestamps null: false
    end
  end
end
