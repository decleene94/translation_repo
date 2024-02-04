class ApplicationController < ActionController::Base
  include HTTParty

  NEWS_API_BASE = 'https://newsdata.io/api/1/news?'
  DEEPL_API_BASE = 'https://api-free.deepl.com/v2/translate'

  def index
    api_key = 'pub_2993851c649bcf95895cf05131da52e4ab6d2'
    category = 'technology'

    @input_languages = shared_languages # for the dropdown
    @output_languages = shared_language_names # for the dropdown
    @countries = shared_countries
    @categories = shared_categories

    @language = params[:input_language] || 'en'
    @target_lang = params[:output_language] || 'EN'
    @selected_country = params[:country] || 'us' # default to US
    @selected_category = params[:category] || 'technology' # default to technology

    response = self.class.get("#{NEWS_API_BASE}", query: { category: @selected_category, country: @selected_country, apikey: api_key, language: @language })

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
      translated_text = translate_text(article["title"], target_lang) # Assuming 'description' needs translation
      article["title"] = translated_text
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

def shared_categories
  %w[business entertainment environment food health politics science sports technology top tourism world]
end


def shared_countries
  {
    'Afghanistan' => 'af',
    'Albania' => 'al',
    'Algeria' => 'dz',
    'Angola' => 'ao',
    'Argentina' => 'ar',
    'Australia' => 'au',
    'Austria' => 'at',
    'Azerbaijan' => 'az',
    'Bahrain' => 'bh',
    'Bangladesh' => 'bd',
    'Barbados' => 'bb',
    'Belarus' => 'by',
    'Belgium' => 'be',
    'Bermuda' => 'bm',
    'Bhutan' => 'bt',
    'Bolivia' => 'bo',
    'Bosnia And Herzegovina' => 'ba',
    'Brazil' => 'br',
    'Brunei' => 'bn',
    'Bulgaria' => 'bg',
    'Burkina Fasco' => 'bf',
    'Cambodia' => 'kh',
    'Cameroon' => 'cm',
    'Canada' => 'ca',
    'Cape Verde' => 'cv',
    'Cayman Islands' => 'ky',
    'Chile' => 'cl',
    'China' => 'cn',
    'Colombia' => 'co',
    'Comoros' => 'km',
    'Costa Rica' => 'cr',
    'Côte d\'Ivoire' => 'ci',
    'Croatia' => 'hr',
    'Cuba' => 'cu',
    'Cyprus' => 'cy',
    'Czech Republic' => 'cz',
    'Denmark' => 'dk',
    'Djibouti' => 'dj',
    'Dominica' => 'dm',
    'Dominican Republic' => 'do',
    'DR Congo' => 'cd',
    'Ecuador' => 'ec',
    'Egypt' => 'eg',
    'El Salvador' => 'sv',
    'Estonia' => 'ee',
    'Ethiopia' => 'et',
    'Fiji' => 'fj',
    'Finland' => 'fi',
    'France' => 'fr',
    'French Polynesia' => 'pf',
    'Gabon' => 'ga',
    'Georgia' => 'ge',
    'Germany' => 'de',
    'Ghana' => 'gh',
    'Greece' => 'gr',
    'Guatemala' => 'gt',
    'Guinea' => 'gn',
    'Haiti' => 'ht',
    'Honduras' => 'hn',
    'Hong Kong' => 'hk',
    'Hungary' => 'hu',
    'Iceland' => 'is',
    'India' => 'in',
    'Indonesia' => 'id',
    'Iraq' => 'iq',
    'Ireland' => 'ie',
    'Israel' => 'il',
    'Italy' => 'it',
    'Jamaica' => 'jm',
    'Japan' => 'jp',
    'Jordan' => 'jo',
    'Kazakhstan' => 'kz',
    'Kenya' => 'ke',
    'Kuwait' => 'kw',
    'Kyrgyzstan' => 'kg',
    'Latvia' => 'lv',
    'Lebanon' => 'lb',
    'Libya' => 'ly',
    'Lithuania' => 'lt',
    'Luxembourg' => 'lu',
    'Macau' => 'mo',
    'Macedonia' => 'mk',
    'Madagascar' => 'mg',
    'Malawi' => 'mw',
    'Malaysia' => 'my',
    'Maldives' => 'mv',
    'Mali' => 'ml',
    'Malta' => 'mt',
    'Mauritania' => 'mr',
    'Mexico' => 'mx',
    'Moldova' => 'md',
    'Mongolia' => 'mn',
    'Montenegro' => 'me',
    'Morocco' => 'ma',
    'Mozambique' => 'mz',
    'Myanmar' => 'mm',
    'Namibia' => 'na',
    'Nepal' => 'np',
    'Netherlands' => 'nl',
    'New Zealand' => 'nz',
    'Niger' => 'ne',
    'Nigeria' => 'ng',
    'North Korea' => 'kp',
    'Norway' => 'no',
    'Oman' => 'om',
    'Pakistan' => 'pk',
    'Panama' => 'pa',
    'Paraguay' => 'py',
    'Peru' => 'pe',
    'Philippines' => 'ph',
    'Poland' => 'pl',
    'Portugal' => 'pt',
    'Puerto Rico' => 'pr',
    'Romania' => 'ro',
    'Russia' => 'ru',
    'Rwanda' => 'rw',
    'Samoa' => 'ws',
    'San Marino' => 'sm',
    'Saudi Arabia' => 'sa',
    'Senegal' => 'sn',
    'Serbia' => 'rs',
    'Singapore' => 'sg',
    'Slovakia' => 'sk',
    'Slovenia' => 'si',
    'Solomon Islands' => 'sb',
    'Somalia' => 'so',
    'South Africa' => 'za',
    'South Korea' => 'kr',
    'Spain' => 'es',
    'Sri Lanka' => 'lk',
    'Sudan' => 'sd',
    'Sweden' => 'se',
    'Switzerland' => 'ch',
    'Syria' => 'sy',
    'Taiwan' => 'tw',
    'Tajikistan' => 'tj',
    'Tanzania' => 'tz',
    'Thailand' => 'th',
    'Tonga' => 'to',
    'Tunisia' => 'tn',
    'Turkey' => 'tr',
    'Turkmenistan' => 'tm',
    'Uganda' => 'ug',
    'Ukraine' => 'ua',
    'United Arab Emirates' => 'ae',
    'United Kingdom' => 'gb',
    'United States of America' => 'us',
    'Uruguay' => 'uy',
    'Uzbekistan' => 'uz',
    'Venezuela' => 've',
    'Vietnam' => 'vi',
    'Yemen' => 'ye',
    'Zambia' => 'zm',
    'Zimbabwe' => 'zw'
  }
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
