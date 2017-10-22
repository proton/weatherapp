require 'rails_helper'

describe ForecastService do
  subject(:forecast) { ForecastService.call('london', '') }

  context 'call with blank city' do
    subject(:forecast) { ForecastService.call('', '') }
    it 'returns error' do
      expect(forecast.error).to eq('City is blank')
    end
  end

  context 'city not found' do
    subject(:forecast) { ForecastService.call('l', '') }
    it 'returns error' do
      allow_any_instance_of(described_class).to receive(:load_request) do
        Faraday::Response.new(body: '{"cod":"404","message":"city not found"}')
      end
      expect(forecast.error).to eq('City not found')
    end
  end

  context 'responce is malformed' do
    it 'returns error' do
      allow_any_instance_of(described_class).to receive(:load_request) do
        Faraday::Response.new(body: '{dadsdas')
      end
      expect(forecast.error).to eq('Parsing error')
    end
  end

  context 'request is correct' do
    it 'returns correct object' do
      allow_any_instance_of(described_class).to receive(:load_request) do
        body = '{"coord":{"lon":-0.13,"lat":51.51},"weather":[{"id":300,"main":"Drizzle","description":"light intensity drizzle","icon":"09d"}],"base":"stations","main":{"temp":280.32,"pressure":1012,"humidity":81,"temp_min":279.15,"temp_max":281.15},"visibility":10000,"wind":{"speed":4.1,"deg":80},"clouds":{"all":90},"dt":1485789600,"sys":{"type":1,"id":5091,"message":0.0103,"country":"GB","sunrise":1485762037,"sunset":1485794875},"id":2643743,"name":"London","cod":200}'
        Faraday::Response.new(body: body)
      end

      expect(forecast.error).to be_nil
      expect(forecast.city).to eq('London')
      expect(forecast.icon).to eq('http://openweathermap.org/img/w/09d.png')
      expect(forecast.weather_state).to eq('light intensity drizzle')
      expect(forecast.temperature).to eq(7.2)
    end
  end
end