# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:response_data) { JSON.parse(response.body).dig("data") }

  describe "#index" do
    before do
      FactoryBot.create_list(:account, 5, user: user)
    end

    it "returns http status success" do
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end

    it "returns the list of users accounts" do
      get :index, params: { user_id: user.id }
      expect(response_data.count).to eq(5)
    end
  end

  describe '#show' do
    let(:account) { FactoryBot.create(:account, user: user, name: "Test account 3") }

    context "when account id is valid and exists" do
      it "returns the valid account" do
        get :show, params: { user_id: user.id, id: account.id }
        aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(response_data.dig("attributes", "account_name")).to eq("Test account 3")
        end
      end
    end

    context "when account id does not exist" do
      it "returns status of 404" do
        get :show, params: { user_id: user.id, id: 1234 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do
    let(:account_params) { FactoryBot.attributes_for(:account, name: 'New Account') }

    context "with valid account attributes" do
      it "creates the account and returns status :created" do
        post :create, params: { user_id: user.id, account: account_params }
        aggregate_failures do
          expect(response).to have_http_status(:created)
          expect(response_data.dig("attributes", "account_name")).to eq("New Account")
        end
      end
    end

    context "when missing or invalid attributes" do
      it "returns 400 with an appropriate error message" do
        post :create, params: { user_id: user.id, account: account_params.merge(name: nil) }
        aggregate_failures do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body).dig("name")).to include("can't be blank")
        end
      end
    end
  end

  describe "#update" do
    let(:account_params) { FactoryBot.attributes_for(:account, name: "Updated Account") }
    let(:account) { FactoryBot.create(:account, user: user) }

    context "when account id does not exist" do
      it "returns status of 404" do
        patch :update, params: { user_id: user.id, id: 1234, account: account_params }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when missing or invalid attributes" do
      it "returns 400 with an appropriate error message" do
        patch :update, params: { user_id: user.id, account: account_params.merge(name: nil), id: account.id }
        aggregate_failures do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body).dig("name")).to include("can't be blank")
        end
      end
    end

    context "with valid account attributes" do
      it "creates the account and returns status :created" do
        patch :update, params: { user_id: user.id, account: account_params, id: account.id }
        aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(response_data.dig("attributes", "account_name")).to eq("Updated Account")
        end
      end
    end
  end

  describe "#destroy" do
    let(:account) { FactoryBot.create(:account, user: user, name: 'Deleted Account') }

    context "when account id does not exist" do
      it "returns status of 404" do
        delete :destroy, params: { user_id: user.id, id: 1234 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with a vaild account id" do
      it "deletes the account successfully" do
        delete :destroy, params: { user_id: user.id, id: account.id }
        expect(Account.where(name: "Deleted Account")).not_to exist
      end
    end
  end
end
