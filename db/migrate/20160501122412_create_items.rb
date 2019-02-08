class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer :product_id
      t.integer :order_id
      t.decimal :price, precision: 8, scale: 4
      t.decimal :amount, precision: 8, scale: 4
      t.decimal :full_price, precision: 8, scale: 4

      t.timestamps
    end
  end
end
