class ForecastsController < ApplicationController
  def index
    @city = params[:city]
    @country = params[:country]
    if @city.present?
      @forecast = ForecastService.call(city: @city, country: @country)
    else
      latitude = rand(20.0..70.0)
      longtitude = rand(-10.0..120.0)
      @forecast = ForecastService.call(latitude: latitude, longtitude: longtitude)
      @city = @forecast.city
    end
  end
end
