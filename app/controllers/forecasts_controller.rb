class ForecastsController < ApplicationController
  def index
    @forecast = ForecastService.call(params[:city], params[:country]) if params[:city]
  end
end
