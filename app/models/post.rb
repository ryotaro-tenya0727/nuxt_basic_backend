class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def image_url
    # 紐づいている画像のURLを取得する
    image.attached? ? url_for(image) : nil
  end
end
