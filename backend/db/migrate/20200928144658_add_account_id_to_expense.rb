# frozen_string_literal: true

class AddAccountIdToExpense < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :expenses, :account, index: { algorithm: :concurrently }
  end
end
