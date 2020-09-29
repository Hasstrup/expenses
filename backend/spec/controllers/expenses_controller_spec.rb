# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpensesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:account) { FactoryBot.create(:account, user: user, balance: 2000) }
  let(:response_data) { JSON.parse(response.body).dig("data") }

  describe "#index" do
    before do
      FactoryBot.create_list(:expense, 4, account: account)
    end

    it "returns the list of expenses for the specified account" do
      get :index, params: { user_id: user.id, account_id: account.id }
      aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response_data.count).to eq(4)
      end
    end
  end

  describe '#show' do
    let(:expense) { FactoryBot.create(:expense, account: account, description: "Test desc") }

    context "when expense exists" do
      it "returns the specified expense" do
        get :show, params: { user_id: user.id, account_id: account.id, id: expense.id }
        aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(response_data.dig("attributes", "description")).to eq("Test desc")
        end
      end
    end

    context "when expense does not exist" do
      it "returns status of 404" do
        patch :update, params: { user_id: user.id, id: 1234, account_id: account.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do
    let(:expense_params) { FactoryBot.attributes_for(:expense, description: "New expense") }

    context "with valid attributes" do
      it "creates the expense and returns status created" do
        post :create, params: { user_id: user.id, account_id: account.id, expense: expense_params }
        aggregate_failures do
          expect(response).to have_http_status(:created)
          expect(response_data.dig("attributes", "description")).to eq("New expense")
        end
      end
    end

    context "when missing or invalid attributes" do
      it "returns 400 with an appropriate error message" do
        post :create, params: { user_id: user.id, expense: expense_params.merge(description: nil), account_id: account.id }
        aggregate_failures do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body).dig("description")).to include("can't be blank")
        end
      end
    end

    context "when expense is greater than account balance" do
      it "returns a 400 with the appropriate error message" do
        post :create, params: { user_id: user.id, expense: expense_params.merge(amount: 4000), account_id: account.id }
        aggregate_failures do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body).dig("balance")).to include("can't be negative")
        end
      end
    end
  end

  describe "#update" do
    let(:expense) { FactoryBot.create(:expense, account: account) }
    let(:expense_params) { FactoryBot.attributes_for(:expense, description: "Updated expense") }

    context "with valid attributes" do
      it "creates the expense and returns status created" do
        patch :update, params: { user_id: user.id, account_id: account.id, expense: expense_params, id: expense.id }
        aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(response_data.dig("attributes", "description")).to eq("Updated expense")
        end
      end
    end

    context "when missing or invalid attributes" do
      it "returns 400 with an appropriate error message" do
        patch :update, params: { user_id: user.id, expense: expense_params.merge(description: nil), account_id: account.id, id: expense.id }
        aggregate_failures do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body).dig("description")).to include("can't be blank")
        end
      end
    end

    context "when reassigning accounts" do
      let(:account_2) { FactoryBot.create(:account, user: user, balance: 800) }

      it "updates both the balances of both previous and current accounts" do
        patch :update, params: {
          user_id: user.id,
          expense: expense_params.merge(account_id: account_2.id),
          account_id: account.id,
          id: expense.id,
        }
        account_2.reload
        account.reload
        aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(account.balance).to eq(2000)
          expect(account_2.balance).to eq(600)
        end
      end
    end
  end

  describe "#destroy" do
    let(:expense) { FactoryBot.create(:expense, account: account, description: "Deleted expense") }

    context "when expense id does not exist" do
      it "returns status of 404" do
        delete :destroy, params: { user_id: user.id, id: 1234, account_id: account.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with a vaild expense id" do
      it "deletes the expense successfully" do
        delete :destroy, params: { user_id: user.id, account_id: account.id, id: expense.id }
        expect(Expense.where(description: "Deleted expense")).not_to exist
      end
    end
  end
end
