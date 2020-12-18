# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(merchant[:attributes]).to have_key(:id)
    expect(merchant[:attributes][:id]).to be_an(Integer)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_an(String)
  end

  it 'can create a new merchant' do
    merchant_params = {
      name: 'I have an amazing name'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)
    created_merchant = Merchant.last
    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it 'can update an existing merchant' do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: 'Super awesome amazing merchant' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq('Super awesome amazing merchant')
  end

  it 'can destroy an merchant' do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    expect { delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)
    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect { Merchant.find(merchant.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can search for an Merchant case insensitive' do
    merchant_base = create(:merchant, name: 'just me')
    create_list(:merchant,10)
    expect(Merchant.count).to eq(11)

    get "/api/v1/merchants/find?name=jUSt"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq(merchant_base.name)
  end

  it 'can search for an Merchant by date' do
    merchant_base = create(:merchant, name: 'just me', created_at: '1/1/2020', updated_at: '1/1/2020')
    create_list(:merchant,10)
    expect(Merchant.count).to eq(11)

    get "/api/v1/merchants/find?created_at=1/1/2020"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq(merchant_base.name)

    get "/api/v1/merchants/find?updated_at=1/1/2020"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq(merchant_base.name)
  end

  it 'can search for an items case insensitive' do
    merchant1 = create(:merchant, name: 'cheese mongrel')
    merchant2 = create(:merchant, name: 'cheese gobbler')
    merchant3 = create(:merchant, name: 'cheese saver')


    expected = [merchant1,merchant2,merchant3]

    create_list(:merchant, 7)
    expect(Merchant.count).to eq(10)

    get "/api/v1/merchants/find_all?name=ChEEsE"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(3)
    counter = 0
    merchants.each do |merchant|
      expect(merchant[:attributes][:name]).to eq(expected[counter].name)
      counter += 1
    end
  end
end
