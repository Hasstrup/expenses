# frozen_string_literal: true

class User < ApplicationRecord
  has_many :accounts, inverse: true
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
