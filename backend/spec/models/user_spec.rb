# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context "Validations" do
    it "builds a valid user" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  context "Associations" do
    it { should have_many(:accounts) }
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
