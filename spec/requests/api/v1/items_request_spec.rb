# frozen_string_literal: true

require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 3)

    get '/api/v1/items'
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)

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

  it 'can get one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(item[:attributes]).to have_key(:id)
    expect(item[:attributes][:id]).to eq(id)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_an(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_an(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item_params = {
      name: 'I have an amazing name',
      description: 'I am an amazing item',
      unit_price: 3.50,
      merchant_id: merchant.id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)
    created_item = Item.last
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update an existing item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'Super awesome amazing item' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item_params)
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Super awesome amazing item')
  end

  it 'can destroy an item' do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect { delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can search for an item case insensitive' do
    merchant = create(:merchant)
    item_base = create(:item, name: 'Super crazy item', description: 'Super Amazing Item!', unit_price: '350',
                              merchant_id: merchant.id)
    create_list(:item, 7)
    expect(Item.count).to eq(8)

    get "/api/v1/items/find?name=SUpEr"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(item[:attributes][:name]).to eq(item_base.name)
      expect(item[:attributes][:description]).to eq(item_base.description)
      expect(item[:attributes][:unit_price]).to eq(item_base.unit_price)
  end

  it 'can search for an items case insensitive' do
    merchant = create(:merchant)
    item_base1 = create(:item, name: 'Super crazy item', description: 'Super crazy Amazing Item!', unit_price: '354',
                              merchant_id: merchant.id)
    item_base2 = create(:item, name: 'Super item', description: 'Super Amazing unbelievable Item!', unit_price: '353',
                              merchant_id: merchant.id)
    item_base3 = create(:item, name: 'Super duper item', description: 'Super Amazing fantastic Item!', unit_price: '352',
                              merchant_id: merchant.id)

    expected = [item_base1,item_base2,item_base3]

    create_list(:item, 7)
    expect(Item.count).to eq(10)

    get "/api/v1/items/find_all?name=SUpEr"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)
    counter = 0
    items.each do |item|
      expect(item[:attributes][:name]).to eq(expected[counter].name)
      expect(item[:attributes][:description]).to eq(expected[counter].description)
      expect(item[:attributes][:unit_price]).to eq(expected[counter].unit_price)
      counter += 1
    end
  end
end
