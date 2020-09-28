# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  context "Validations" do
    it "builds a valid account" do
      expect(FactoryBot.build(:account)).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:balance) }
    it { should validate_numericality_of(:number) }
  end

  context "associations" do
    it { should belong_to(:user) }
  end
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
