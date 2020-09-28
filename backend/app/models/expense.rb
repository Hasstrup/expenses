# frozen_string_literal: true

class Expense < ApplicationRecord
  validates :amount, :date, :description, presence: true
  validates :amount, numericality: { greater_than: 0, only_integer: true }

  belongs_to :account
  after_create :balance_account

  private

  def balance_account
    ActiveRecord::Base.transaction do
      account.update!(balance: account.balance - amount)
      # moving this to controller
      if account_id_changed?
        previous_account = Account.find(account_id_was) if account_id_was
        previous_account.update!(balance: previous_account.balance + amount)
      end
    end
  end
end

# == Schema Information
#
# Table name: expenses
#
#  id          :bigint           not null, primary key
#  amount      :integer
#  date        :date
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#
# Indexes
#
#  index_expenses_on_account_id  (account_id)
#
