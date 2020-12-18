# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { Faker::Name.name }

    trait :with_invoices_items_and_transactions do
      after(:create) do |merchant|
        merchant.items << FactoryBot.create(:item, :with_invoice_items)
        merchant.invoices << FacoryBot.create(:invoices, :with_invoice_items)
      end
    end
  end

  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end

  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.within(range: 0.01..100.00).round(2) }
    merchant
  end

  factory :invoice do
    merchant
    customer
    status { 'shipped' }
  end

  factory :invoice_item do
    item
    invoice
    quantity { Faker::Number.within(range: 1..100) }
    unit_price { item.unit_price }
  end

  factory :transaction do
    invoice
    credit_card_number { Faker::Number.within(range: 1_000_000_000_000_000..9_999_999_999_999_999) }
    credit_card_expiration_date { "#{rand(1..12).to_s.rjust(2, '0')}/#{rand(1..30).to_s.rjust(2, '0')}" }
    result { %w[success failed].sample }
  end
end
