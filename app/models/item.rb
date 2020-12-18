class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_by_params(params)
    search_query(params).first
  end

  def self.find_all_by_params(params)
    search_query(params)
  end

  def self.search_query(params)
    query = Item.all
    query = query.where('lower(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].nil?
    query = query.where('lower(description) LIKE ?', "%#{params[:description].downcase}%") unless params[:description].nil?
    query = query.where('merchant_id = ?', params[:merchant_id]) unless params[:merchant_id].nil?
    query = query.where('Date(created_at) = ?', params[:created_at]) unless params[:created_at].nil?
    query = query.where('Date(updated_at) = ?',params[:updated_at]) unless params[:updated_at].nil?
    query
  end
end
