class ForecastService
  include ::Service

  attr_reader :city
  attr_reader :country
  attr_reader :latitude
  attr_reader :longtitude
  attr_reader :forecast
  attr_reader :response

  def initialize(city: nil, country: nil, latitude: nil, longtitude: nil)
    @city = city
    @country = country
    @latitude = latitude
    @longtitude = longtitude
    @forecast = OpenStruct.new
  end

  def call
    process_request
    parse_response unless forecast.error
    forecast
  end

  private

  def load_request
    return err_response('OPEN_WEATHER_MAP_API_KEY is blank') if OPEN_WEATHER_MAP_API_KEY.blank?
    url = 'http://api.openweathermap.org/data/2.5/weather'
    params = { appid: OPEN_WEATHER_MAP_API_KEY }
    if city.present?
      # TODO: country code support
      # query = country.present? ? "#{city},#{country}" : city
      query = city
      params[:q] = query
    else
      params[:lat] = latitude
      params[:lon] = longtitude
    end
    Faraday.get url, params
  end

  def process_request
    return err_response('You should provide city or latitude & longtitude') if city.blank? && (latitude.nil? || longtitude.nil?)
    begin
      @response = load_request
    rescue
      return err_response('Network error')
    end
  end

  def parse_response
    forecast.raw_response = JSON.parse(@response.body)
    return err_response('City not found') if forecast.raw_response['cod'].to_i == 404

    forecast.city = forecast.raw_response['name']
    weather = forecast.raw_response['weather'].first
    forecast.icon = "http://openweathermap.org/img/w/#{weather['icon']}.png"
    forecast.weather_state = weather['description']
    main_data = forecast.raw_response['main']
    forecast.temperature = kelvin_to_celsius(main_data['temp']).round(1)
  rescue
    err_response 'Parsing error'
  end

  def err_response(error_text)
    forecast.error = error_text
  end

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
  end
end