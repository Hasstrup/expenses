# frozen_string_literal: true

require "rails_helper"

RSpec.describe Expense, type: :model do
  context "validations" do
    it "builds a valid object" do
      expect(FactoryBot.build(:expense)).to be_valid
    end

    %i(amount date description).each do |attribute|
      it { should validate_presence_of(attribute) }
    end

    it { should validate_numericality_of(:amount) }
  end

  context "associations" do
    it { should belong_to(:account) }
  end

  describe 'balance_account' do
    let(:account) { FactoryBot.create(:account) }

    it 'updates the balance of account on create' do
      expect do
        FactoryBot.create(:expense, account: account)
      end.to change(account, :balance)
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
