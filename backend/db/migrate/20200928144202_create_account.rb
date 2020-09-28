# frozen_string_literal: true

class CreateAccount < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.bigint :number, index: true
      t.bigint :balance, default: 1000
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
