# frozen_string_literal: true

# This is a comment

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        renderer(Merchant.all)
      end

      def show
        renderer(Merchant.find(params[:id]))
      end

      def create
        renderer(Merchant.create(merchant_params))
      end

      def update
        renderer(Merchant.update(params[:id], merchant_params))
      end

      def destroy
        Merchant.destroy(params[:id])
      end

      def find
        renderer(Merchant.find_by_params(merchant_params))
      end

      def find_all
        renderer(Merchant.find_all_by_params(merchant_params))
      end

      def most_revenue
        renderer(Merchant.most_revenue(merchant_params[:quantity]))
      end

      def most_items
        renderer(Merchant.most_items(merchant_params[:quantity]))
      end

      def revenue
        merchant_params[:id].nil? ? task = Merchant.revenue(merchant_params[:start],merchant_params[:end]) :
                                    task = Merchant.find(merchant_params[:id]).revenue_merchant
        render json: RevenuesSerializer.serialize_data(task[0])
      end

      private

      def merchant_params
        params.permit(:name, :id, :quantity, :start, :end, :created_at, :updated_at)
      end

      def renderer(task)
        render json: MerchantSerializer.new(task)
      end
    end
  end
end
