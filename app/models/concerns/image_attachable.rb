# frozen_string_literal: true

# Shared validation for Active Storage image uploads (post image, user avatar).
module ImageAttachable
  extend ActiveSupport::Concern

  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_IMAGE_SIZE = 5.megabytes

  class_methods do
    def validates_attached_image(name, error_key: name)
      validate do
        attachment = public_send(name)
        next unless attachment.attached?

        unless attachment.content_type.in?(ALLOWED_IMAGE_TYPES)
          errors.add(error_key, "должна быть JPEG, PNG, WebP или GIF")
        end

        if attachment.byte_size > MAX_IMAGE_SIZE
          errors.add(error_key, "не должна быть больше 5 МБ")
        end
      end
    end
  end
end
