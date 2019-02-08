class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :ean
      t.integer :type_id

      t.timestamps
    end
    add_index :products, %i[name ean], unique: true
  end
end
