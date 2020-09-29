# frozen_string_literal: true

class ExpenseSerializer
  include FastJsonapi::ObjectSerializer

  attributes :description, :amount, :date
end
