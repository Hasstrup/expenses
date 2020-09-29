# frozen_string_literal: true

class ExpensesController < ApplicationController
  def index
    render json: ExpenseSerializer.new(account.expenses.order(date: :desc))
  end

  def show
    render json: ExpenseSerializer.new(expense)
  end

  def create
    expense = account.expenses.create!(expense_params)
    render json: ExpenseSerializer.new(expense), status: :created
  end

  def update
    ActiveRecord::Base.transaction do
      expense.assign_attributes(expense_params)
      balance_accounts(prev_account_id: expense.account_id_was) if expense.account_id_changed?
      expense.save!
    end

    render json: ExpenseSerializer.new(expense)
  end

  def destroy
    head :no_content if expense.destroy
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :date, :description, :account_id)
  end

  def account
    @account ||= user.accounts.find(params[:account_id])
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def expense
    @expense ||= account.expenses.find(params[:id])
  end

  def balance_accounts(prev_account_id:)
    prev_account = user.accounts.find(prev_account_id)
    current_account = user.accounts.find(expense.account_id)
    prev_account.update(balance: prev_account.balance + expense.amount)
    current_account.update(balance: current_account.balance - expense.amount)
  end
end
