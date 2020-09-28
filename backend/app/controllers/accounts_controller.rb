# frozen_string_literal: true

class AccountsController < ApplicationController
  def create
  end

  private

  def account_params
    params.require(:account).permit(:name, :number)
  end
end