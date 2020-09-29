# frozen_string_literal: true

class AccountSerializer
  include FastJsonapi::ObjectSerializer

  attributes :balance, :user_id

  attribute :account_name do |object|
    object.name
  end

  attribute :bank_account_number do |object|
    object.number
  end
end
