# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :currency, default: 'EUR'
      t.decimal :price, precision: 8, scale: 4
      t.decimal :discount, precision: 8, scale: 4
      t.decimal :depozit, precision: 8, scale: 4
      t.string :no, unique: true
      t.decimal :maxima, precision: 8, scale: 4

      t.timestamps
    end

    add_index :orders, :no, unique: true
  end
end
