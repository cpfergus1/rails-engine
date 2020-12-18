require 'rails_helper'
describe 'buisness intelligence' do
  before(:each) do
    @m1 = create(:merchant, name: "I'm da second best")
    @m2 = create(:merchant, name: "I'm da fifth best")
    @m3 = create(:merchant, name: "I'm da fourth best")
    @m4 = create(:merchant, name: "I'm da disqualified gent")
    @m5 = create(:merchant, name: "I'm da first best")
    @m6 = create(:merchant, name: "I'm da third best")

    @i1 = create(:item, unit_price: 20.00, merchant_id: @m1.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @i2 = create(:item, unit_price: 10.00, merchant_id: @m2.id, created_at: '2013-03-09', updated_at: '2013-03-09')
    @i3 = create(:item, unit_price: 100.00, merchant_id: @m3.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @i4 = create(:item, unit_price: 5.00, merchant_id: @m4.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @i5 = create(:item, unit_price: 55.00, merchant_id: @m5.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @i6 = create(:item, unit_price: 35.00, merchant_id: @m6.id, created_at: '2012-03-09', updated_at: '2012-03-09')

    @in1 = create(:invoice, merchant_id: @m1.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @in2 = create(:invoice, merchant_id: @m2.id, created_at: '2013-03-09', updated_at: '2013-03-09')
    @in3 = create(:invoice, merchant_id: @m3.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @in4 = create(:invoice, merchant_id: @m4.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @in5 = create(:invoice, merchant_id: @m5.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @in6 = create(:invoice, merchant_id: @m6.id, created_at: '2012-03-09', updated_at: '2012-03-09')

    @ii1 = create(:invoice_item, quantity: 40, unit_price: @i1.unit_price, invoice_id: @in1.id, item_id: @i1.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @ii2 = create(:invoice_item, quantity: 5, unit_price: @i2.unit_price, invoice_id: @in2.id, item_id: @i2.id, created_at: '2012-03-09', updated_at: '2013-03-09')
    @ii3 = create(:invoice_item, quantity: 1, unit_price: @i3.unit_price, invoice_id: @in3.id, item_id: @i3.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @ii4 = create(:invoice_item, quantity: 600, unit_price: @i4.unit_price, invoice_id: @in4.id, item_id: @i4.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @ii5 = create(:invoice_item, quantity: 25, unit_price: @i5.unit_price, invoice_id: @in5.id, item_id: @i5.id, created_at: '2012-03-09', updated_at: '2012-03-09')
    @ii6 = create(:invoice_item, quantity: 10, unit_price: @i6.unit_price, invoice_id: @in6.id, item_id: @i6.id, created_at: '2012-03-09', updated_at: '2012-03-09')

    @t1 = create(:transaction, invoice_id: @in1.id, result: 'success', created_at: '2012-03-09', updated_at: '2012-03-09')
    @t2 = create(:transaction, invoice_id: @in2.id, result: 'success', created_at: '2012-03-09', updated_at: '2012-03-09')
    @t3 = create(:transaction, invoice_id: @in3.id, result: 'success', created_at: '2012-03-09', updated_at: '2012-03-09')
    @t4 = create(:transaction, invoice_id: @in4.id, result: 'failed', created_at: '2012-03-09', updated_at: '2012-03-09')
    @t5 = create(:transaction, invoice_id: @in5.id, result: 'success', created_at: '2012-03-09', updated_at: '2012-03-09')
    @t6 = create(:transaction, invoice_id: @in6.id, result: 'success', created_at: '2012-03-09', updated_at: '2012-03-09')
  end

  it 'can search for the highest revenue merchants' do
    expected = [@m5,@m1,@m6,@m3,@m2]

    get "/api/v1/merchants/most_revenue?quantity=7"
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(5)
    counter = 0
    merchants.each do |merchant|
      expect(merchant[:attributes][:name]).to eq(expected[counter].name)
      counter += 1
    end
  end

  it 'can search for the highest sold items' do
    expected = [@m1,@m5,@m6,@m2,@m3]

    get "/api/v1/merchants/most_items?quantity=8"
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(5)
    counter = 0
    merchants.each do |merchant|
      expect(merchant[:attributes][:name]).to eq(expected[counter].name)
      counter += 1
    end
  end

  it 'can get revenue between two dates' do
    m1_revenue = @ii1[:quantity] * @ii1[:unit_price]
    m2_revenue = @ii2[:quantity] * @ii2[:unit_price]
    m3_revenue = @ii3[:quantity] * @ii3[:unit_price]
    m4_revenue = @ii4[:quantity] * @ii4[:unit_price]
    m5_revenue = @ii5[:quantity] * @ii5[:unit_price]
    m6_revenue = @ii6[:quantity] * @ii6[:unit_price]
    expected = [m1_revenue,m3_revenue,m5_revenue,m6_revenue].sum
    avoiding = [m1_revenue,m2_revenue,m3_revenue,m4_revenue,m5_revenue,m6_revenue].sum

    get '/api/v1/revenue?start=2012-03-09&end=2012-03-24'
    revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(revenue[:attributes][:revenue]).to_not eq(avoiding)
    expect(revenue[:attributes][:revenue]).to eq(expected)
  end

  it 'can get revenue for one merchant' do
    expected = @ii1[:quantity] * @ii1[:unit_price]
    get "/api/v1/merchants/#{@m1.id}/revenue"
    revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(revenue[:attributes][:revenue]).to eq(expected)
  end
end
