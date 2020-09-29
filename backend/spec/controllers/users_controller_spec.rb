# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:response_data) { JSON.parse(response.body).dig("data") }

  describe "create" do
    context "when attributes are set correctly" do
      let(:user_attributes) { FactoryBot.attributes_for(:user) }

      it "returns http status created" do
        post :create, params: { user: user_attributes }
        expect(response).to have_http_status(:created)
      end

      it "creates the user successfully" do
        post :create, params: { user: user_attributes }
        expect(response_data.dig("attributes", "name")).to eq("Test User")
      end
    end
  end
end
