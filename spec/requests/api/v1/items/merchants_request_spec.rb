# frozen_string_literal: true

require 'rails_helper'

describe 'Items/{id}/merchants API' do
  it 'sends the merchant that owns the item' do
    merchant = create(:merchant)
    create_list(:item, 20, merchant_id: merchant.id)

    other_merchant = create(:merchant)
    create_list(:item, 5, merchant_id: other_merchant.id)

    get "/api/v1/items/#{Item.last.id}/merchants"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes]).to have_key(:id)
    expect(merchant[:attributes][:id]).to be_an(Integer)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_an(String)
    expect(merchant[:attributes][:name]).to eq(other_merchant.name)
  end
end
