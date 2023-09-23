class ApplicationController < ActionController::Base
  include HTTParty

  NEWS_API_BASE = 'https://newsdata.io/api/1/news?'
  DEEPL_API_BASE = 'https://api-free.deepl.com/v2/translate'

  def index
    api_key = 'pub_2993851c649bcf95895cf05131da52e4ab6d2'
    category = 'technology'

    @input_languages = shared_languages # for the dropdown
    @output_languages = shared_language_names # for the dropdown

    @language = params[:input_language] || 'en'
    @target_lang = params[:output_language] || 'EN'

    response = self.class.get("#{NEWS_API_BASE}", query: { category: category, apikey: api_key, language: @language })

    if response.success?
      news_articles = response.parsed_response['results'] || []
      @news = translate_articles(news_articles, @target_lang)
    else
      raise StandardError, 'Failed to fetch news from newsdata.io'
    end
  end

  private

  def translate_articles(articles, target_lang)
    translated_articles = []

    articles.each do |article|
      translated_text = translate_text(article["content"], target_lang) # Assuming 'description' needs translation
      article["content"] = translated_text
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

  def shared_languages
    %w[bg cs da de el en es et fi fr hu id it ja ko lt nl pl pt ro ru sk sv tr uk zh]
  end

  def shared_language_names
    {
      'bg' => 'Bulgarian',
      'cs' => 'Czech',
      'da' => 'Danish',
      'de' => 'German',
      'el' => 'Greek',
      'en' => 'English',
      'es' => 'Spanish',
      'et' => 'Estonian',
      'fi' => 'Finnish',
      'fr' => 'French',
      'hu' => 'Hungarian',
      'id' => 'Indonesian',
      'it' => 'Italian',
      'ja' => 'Japanese',
      'ko' => 'Korean',
      'lt' => 'Lithuanian',
      'nl' => 'Dutch',
      'pl' => 'Polish',
      'pt' => 'Portuguese',
      'ro' => 'Romanian',
      'ru' => 'Russian',
      'sk' => 'Slovak',
      'sv' => 'Swedish',
      'tr' => 'Turkish',
      'uk' => 'Ukrainian',
      'zh' => 'Chinese'
    }
  end
end
