# frozen_string_literal: true

class AccountsController < ApplicationController
  def index
    render json: AccountSerializer.new(user.accounts)
  end

  def show
    render json: AccountSerializer.new(account)
  end

  def create
    account = user.accounts.create!(account_params)
    render json: AccountSerializer.new(account), status: :created
  end

  def update
    account.update!(account_params)
    render json: AccountSerializer.new(account)
  end

  def destroy
    head :no_content if account.destroy
  end

  private

  def account_params
    params.require(:account).permit(:name, :number)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def account
    @account ||= user.accounts.find(params[:account_id])
  end
end
