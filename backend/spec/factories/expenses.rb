# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    description { "Test description" }
    amount { 200 }
    date { Date.today }

    account
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
