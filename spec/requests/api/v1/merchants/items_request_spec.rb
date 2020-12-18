# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants/{id}/Items API' do
  it 'sends a list of items from the merchant' do
    merchant = create(:merchant)
    create_list(:item, 20, merchant_id: merchant.id)

    other_merchant = create(:merchant)
    create_list(:item, 5, merchant_id: other_merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(20)

    items.each do |item|
      expect(item[:attributes]).to have_key(:id)
      expect(item[:attributes][:id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end
