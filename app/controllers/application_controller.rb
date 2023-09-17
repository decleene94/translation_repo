class ApplicationController < ActionController::Base
  include HTTParty

  NEWS_API_BASE = 'https://api.thenewsapi.com/v1'
  DEEPL_API_BASE = 'https://api-free.deepl.com/v2/translate'

  def index
    api_key = 'qVeNafpSGQXWJ5aRbqdj8kIxKW5noNfTMZK4C7DY'
    category = 'food'
    language = 'de'

    response = self.class.get("#{NEWS_API_BASE}/news/top", query: { category: category, api_token: api_key, language: language })

    if response.success?
      news_articles = response.parsed_response['data']
      @news = translate_articles(news_articles, 'EN')
    else
      raise StandardError, 'Failed to fetch news from thenewsapi.com'
    end
  end

  private

  def translate_articles(articles, target_lang)
    translated_articles = []

    articles.each do |article|
      translated_text = translate_text(article["description"], target_lang) # Assuming 'description' needs translation
      article["description"] = translated_text
      translated_articles << article
    end

    translated_articles
  end

  def translate_text(text, target_lang)
    deepl_api_key = "4da90edc-c4fa-fa1b-acc1-9cbecfc1f453:fx"
    response = self.class.post(
      DEEPL_API_BASE,
      query: { auth_key: deepl_api_key, text: text, target_lang: target_lang }
    )

    if response.success?
      response.parsed_response["translations"][0]["text"]
    else
      raise StandardError, "Failed to translate text with DeepL API: #{response.body}"
    end
  end
end


=begin
class ApplicationController < ActionController::Base
  include HTTParty

  base_uri 'https://api.thenewsapi.com/v1'

  def index
    api_key = 'qVeNafpSGQXWJ5aRbqdj8kIxKW5noNfTMZK4C7DY'
    category = 'food'
    language = 'fr'

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

end

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

end
=end
