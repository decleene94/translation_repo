class ApplicationController < ActionController::Base
  include HTTParty

  base_uri 'https://api.thenewsapi.com/v1'

  def index
    api_key = 'qVeNafpSGQXWJ5aRbqdj8kIxKW5noNfTMZK4C7DY'
    category = 'technology'

    response = self.class.get('/news/top', query: { category: category, api_token: api_key })

    if response.success?
      @news = response.parsed_response['data'] # Access the 'data' array
    else
      raise StandardError, 'Failed to fetch news from thenewsapi.com'
    end
  end
end
