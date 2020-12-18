# frozen_string_literal: true

# This is a comment
module Api
  module V1
    module Items
      class MerchantsController < Api::V1::MerchantsController
        def index
          render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
        end
      end
    end
  end
end
