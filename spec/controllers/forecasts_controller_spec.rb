# class ForecastsController < ApplicationController
#   def index
#     @forecast = ForecastService.call(params[:city], params[:country]) if params[:city]
#   end
# end

require 'rails_helper'

describe ForecastsController, type: :controller do
  describe 'GET #index' do
    context 'without params' do
      it 'has a 200 status code' do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end
end