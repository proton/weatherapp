# class ForecastsController < ApplicationController
#   def index
#     @forecast = ForecastService.call(params[:city], params[:country]) if params[:city]
#   end
# end

require 'rails_helper'

describe 'searching forecasts', type: :feature do
  it 'shows city weather' do
    visit root_url
    fill_in 'City', with: 'London'
    click_button 'Show'
    expect(page).to have_content 'Weather in London'
  end

  it 'shows error if city not found' do
    visit root_url
    fill_in 'City', with: 'L'
    click_button 'Show'
    expect(page).to have_content 'Error'
    expect(page).to have_content 'City not found'
  end
end