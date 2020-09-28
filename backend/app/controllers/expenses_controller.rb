# frozen_string_literal: true

class ExpensesController < ApplicationController
  def index
    render json: Expense.order(date: :desc)
  end

  def shows
    render json: expense
  end

  def create
    expense = Expense.create!(expense_params)
    render json: expense
  end

  def update
    expense.update!(expense_params)
    render json: expense
  end

  def destroy
    head :no_content if expense.destroy
  end

  private

  def expense_params
    params.permit(:amount, :date, :description)
  end

  def expense
    @expense ||= Expense.find(params[:id])
  end
end
