class ChatgptService
  require 'open-uri'
  require 'fileutils'
  include HTTParty

  attr_reader :api_url, :options, :model, :message
  # モデルは予め設定しておく
  def initialize(message, model = 'gpt-3.5-turbo')
		# 機密ファイルを呼び出している
    api_key = Rails.application.credentials.chatgpt_api_key
    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}" # ここで 'api_key' を使用
      }
    }
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    @message = message
  end

  def call
		# userからのメッセージに対し一つ回答を与える
    body = {
      model:,
      messages: [{ role: 'user', content: message }]
    }
    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 100)
    raise response['error']['message'] unless response.code == 200
		# レスポンスはjson形式になっており、下記の形を取得することで返答本文"content"のみを得る
    response['choices'][0]['message']['content']
  end

  def generate_image_with_dalle2(prompt)
		# モデルのパラメータを指定する。
    body = {
      model: "dall-e-3",
      prompt: prompt,
      n: 1,
      size: "1024x1024"
    }
		# どこにアクセスするか（エンドポイント）の設定。OpenAI社サイトで確認
    response = HTTParty.post("https://api.openai.com/v1/images/generations",
                             body: body.to_json,
                             headers: options[:headers],
                             timeout: 100)
    raise response['error']['message'] unless response.code == 200

		# レスポンスで得るのはURL
    response['data'][0]['url']
  end

  # 画像をダウンロードする関数
  def self.download_image(prompt)
		# 上で指定したgenerate_imageにプロンプトを入力して生成画像のURLを得る
    image_url = generate_image(prompt)
    # ファイル名を生成。他の画像と名前が重複しないようにタイムスタンプをファイル名とする（例：「20230101_123456.png」）
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    file_name = "#{timestamp}.png"
		# ファイルの保存先はpublic/generated_imagesとする
    file_path = Rails.root.join('public', 'generated_images', file_name)
    
    # 保存先ディレクトリがない場合は作成する
    FileUtils.mkdir_p(File.dirname(file_path))

    # 画像をダウンロードして保存
    URI.open(image_url) do |image|
      File.open(file_path, 'wb') do |file|
        file.write(image.read)
      end
    end
    # ファイル名を戻り値とするので、この情報をもとに投稿と紐づける
    file_name
  rescue StandardError => e
    Rails.logger.error "Image download failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    nil
  end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end
end