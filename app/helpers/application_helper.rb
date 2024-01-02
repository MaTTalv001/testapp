module ApplicationHelper
  def image_save_path_for(image_name)
    if Rails.env.production?
      "/var/lib/data/generated_images/#{image_name}" # 本番環境でのURL
    else
      Rails.root.join('public', 'generated_images', image_name) # 開発環境でのローカルパス
    end
  end

  def image_load_path_from(image_name)
    if Rails.env.production?
      "/var/lib/data/generated_images/#{image_name}" # 本番環境でのURL
    else
      "/generated_images/#{image_name}" # 開発環境でのローカルパス
    end
  end

  def current_user_board_count
    current_user.boards.count if current_user
  end
end
