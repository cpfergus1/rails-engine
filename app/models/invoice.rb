# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  scope :has_shipped, -> { where(status: 'shipped') }
  scope :created_from_to, ->(start,stop) { where("Date(invoices.created_at) >= ? AND Date(invoices.created_at) <= ?", start,stop) }
  scope :created_from, ->(start) { where("invoices.created_at >= ?", start) }
  scope :created_by, ->(stop) { where("invoices.created_at <= ?", stop) }
end
