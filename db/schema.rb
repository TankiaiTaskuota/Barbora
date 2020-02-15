# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_05_01_122412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'items', id: :serial, force: :cascade do |t|
    t.integer 'product_id'
    t.integer 'order_id'
    t.decimal 'price', precision: 8, scale: 4
    t.decimal 'amount', precision: 8, scale: 4
    t.decimal 'full_price', precision: 8, scale: 4
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'orders', id: :serial, force: :cascade do |t|
    t.string 'currency', default: 'EUR'
    t.decimal 'price', precision: 8, scale: 4
    t.decimal 'discount', precision: 8, scale: 4
    t.decimal 'depozit', precision: 8, scale: 4
    t.string 'no'
    t.decimal 'maxima', precision: 8, scale: 4
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['no'], name: 'index_orders_on_no', unique: true
  end

  create_table 'products', id: :serial, force: :cascade do |t|
    t.string 'name'
    t.string 'ean'
    t.integer 'type_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name', 'ean'], name: 'index_products_on_name_and_ean', unique: true
  end

end
