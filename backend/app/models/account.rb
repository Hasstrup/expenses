# frozen_string_literal: true

class Account < ApplicationRecord
  validates :name, presence: true
  validates_numericality_of :number
  validates :balance, presence: true, numericality: { greater_than: 0, only_integer: true }

  belongs_to :user
  has_many :expenses, inverse: true
end

# == Schema Information
#
# Table name: accounts
#
#  id         :bigint           not null, primary key
#  balance    :bigint           default(1000)
#  deleted_at :datetime
#  name       :string
#  number     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_accounts_on_deleted_at  (deleted_at)
#  index_accounts_on_number      (number)
#  index_accounts_on_user_id     (user_id)
#
