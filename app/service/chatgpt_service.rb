class ChatgptService
  require 'open-uri'
  require 'fileutils'
  include HTTParty

  # DALL-E 3のAPIエンドポイント
  DALLE_API_URL = 'https://api.openai.com/v1/images/generations'

  def self.generate_image_with_dalle3(prompt)
    api_key = Rails.application.credentials.chatgpt_api_key
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{api_key}"
    }

    body = {
      model: "dall-e-3",
      prompt: "japanese anime, #{prompt}",
      n: 1,
      size: "1024x1024"
    }

    response = HTTParty.post(DALLE_API_URL, body: body.to_json, headers: headers, timeout: 100)
    raise response['error']['message'] unless response.code == 200

    response['data'][0]['url']
  end

  def self.download_image(prompt)
    image_url = generate_image_with_dalle3(prompt)
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    file_name = "#{timestamp}.png"

    if Rails.env.production?
      file_path = "/var/lib/data/generated_images/#{file_name}" # 本番環境でのURL
    else
      file_path = Rails.root.join('public', 'generated_images', file_name) # 開発環境でのローカルパス
    end

    # file_path = Rails.root.join('public', 'generated_images', file_name)
    # 本番環境と開発環境で分ける
    # file_path = image_save_path_for(file_name)
    
    FileUtils.mkdir_p(File.dirname(file_path))
    URI.open(image_url) do |image|
      File.open(file_path, 'wb') do |file|
        file.write(image.read)
      end
    end

    file_name
  rescue StandardError => e
    Rails.logger.error "Image download failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    nil
  end
end
