class ForecastService
  include ::Service

  attr_reader :city
  attr_reader :country
  attr_reader :forecast
  attr_reader :response

  def initialize(city, country)
    @city = city if city.present?
    @country = country if country.present?
    @forecast = OpenStruct.new
  end

  def call
    process_request
    forecast
  end

  private

  def process_request
    return err_response('City is blank') if city.blank?
    return err_response('OPEN_WEATHER_MAP_API_KEY is blank') if OPEN_WEATHER_MAP_API_KEY.blank?

    query = "#{city}"
    # TODO: country code support
    url = 'http://api.openweathermap.org/data/2.5/weather'
    begin
      @response = Faraday.get url, q: query, appid: OPEN_WEATHER_MAP_API_KEY
    rescue
      return err_response('Network error')
    end
    parse_response
  end

  def parse_response
    forecast.raw_response = JSON.parse(@response.body)
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