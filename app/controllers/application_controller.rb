class ApplicationController < ActionController::Base
  include HTTParty

  base_uri 'https://api.thenewsapi.com/v1'

  def index
    api_key = 'qVeNafpSGQXWJ5aRbqdj8kIxKW5noNfTMZK4C7DY'
    category = 'food'
    language = 'es'

    response = self.class.get('/news/top', query: { category: category, api_token: api_key, language: language })

    if response.success?
      @news = news_articles = response.parsed_response['data']
      #news_articles = response.parsed_response['data'] # Access the 'data' array
      #@news = translate_articles(news_articles, language)
    else
      raise StandardError, 'Failed to fetch news from thenewsapi.com'
    end
  end

  private
=begin
  def translate_articles(articles, target_language)
    translated_articles = []
    articles.each do |article|
      translated_article = translate_text(article['description'], target_language)
      translated_articles << { 'title' => article['title'], 'description' => translated_article }
    end
    translated_articles
  end

  def translate_text(text, target_language)
  # Instantiates a client
  require "google/cloud/translate"

  translate = Google::Cloud::Translate.translation_v2_service

  # The target language
  target = target_language

  # Translates some text into the target language
  translation = translate.translate_text text: text, target_language: target, parent: "projects/#{ENV['psychic-raceway-386709']}/locations/global"

  translation.translations.first.translated_text
end
=end
end
