# frozen_string_literal: true

# This is a comment

module Api
  module V1
    module Merchants
      class ItemsController < Api::V1::ItemsController
        def index
          render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
        end
      end
    end
  end
end
