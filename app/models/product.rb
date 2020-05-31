# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :items, dependent: :destroy
end
