class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "画像ファイルの大きさは5MBまでです。")
      end
    end
end
