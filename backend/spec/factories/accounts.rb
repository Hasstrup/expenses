# frozen_string_literal: true

FactoryBot.define do
    factory :account do
      name { "Test account" }
      number { 1234567890 }
      

      association :user, factory: :user
    end
end
