# frozen_string_literal: true

# Cookie session: HttpOnly (за замовчуванням), SameSite=Lax, Secure у production.
Rails.application.config.session_store :cookie_store,
  key: "_logichub_session",
  same_site: :lax,
  secure: Rails.env.production?,
  httponly: true
