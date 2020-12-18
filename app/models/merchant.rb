# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_by_params(params)
    search_query(params)[0]
  end

  def self.find_all_by_params(params)
    search_query(params)
  end

  def self.search_query(params)
    query = Merchant.all
    query = query.where('name ilike ?', "%#{params[:name]}%") unless params[:name].nil?
    query = query.where('Date(created_at) = ?', params[:created_at]) unless params[:created_at].nil?
    query = query.where('Date(updated_at) = ?', params[:updated_at]) unless params[:updated_at].nil?
    query
  end

  def self.most_revenue(params = 5)
    most_of('sum(quantity * unit_price)','total_revenue', params)
  end

  def self.most_items(params = 5)
    most_of('sum(quantity)','total_items_sold', params)
  end

  def self.most_of(aggregate, column_name, params)
    joins(invoices: [:invoice_items, :transactions]).
    select("merchants.*, #{aggregate} AS #{column_name}").
    merge(Transaction.successful).
    group(:id).
    order("#{column_name} DESC").
    limit(params)
  end

  def self.revenue(start, stop)
    joins(invoices: [:invoice_items, :transactions]).
    select("sum(quantity * unit_price) AS revenue").
    merge(Invoice.created_from_to(start,stop).has_shipped).
    merge(Transaction.successful)
  end

  def revenue_merchant
    invoices.joins(:invoice_items, :transactions).
    select("sum(quantity * unit_price) AS revenue").
    merge(Transaction.successful).
    merge(Invoice.has_shipped)
  end
end
