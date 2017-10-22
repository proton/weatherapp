require 'rails_helper'

describe 'searching forecasts', type: :feature do
  it 'shows city weather' do
    allow(ForecastService).to receive(:call) do
      OpenStruct.new(city: 'London', icon: '')
    end

    visit root_url
    fill_in 'City', with: 'London'
    click_button 'Show'
    expect(page).to have_content 'Weather in London'
  end

  it 'shows error if city not found' do
    allow(ForecastService).to receive(:call) do
      OpenStruct.new(error: 'City not found')
    end

    visit root_url
    fill_in 'City', with: 'L'
    click_button 'Show'
    expect(page).to have_content 'Error'
    expect(page).to have_content 'City not found'
  end
end