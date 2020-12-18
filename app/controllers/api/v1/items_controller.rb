# frozen_string_literal: true

# This is a comment

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        render json: ItemSerializer.new(Item.create(item_params))
      end

      def update
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      end

      def destroy
        Item.destroy(params[:id])
      end

      def find
        render json: ItemSerializer.new(Item.find_by_params(item_params))
      end

      def find_all
        render json: ItemSerializer.new(Item.find_all_by_params(item_params))
      end

      private

      def item_params
          params.permit(:name, :description, :unit_price, :merchant_id, :id, :created_at, :updated_at)
      end
    end
  end
end
