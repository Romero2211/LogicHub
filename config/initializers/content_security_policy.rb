# frozen_string_literal: true

# Content Security Policy — зменшує шкоду від XSS (обмежує скрипти/фрейми).
# Importmap + Propshaft + Active Storage працюють з :self.
# blob: потрібен для клієнтського превʼю зображень (URL.createObjectURL).

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :data
    policy.img_src     :self, :https, :data, :blob
    policy.object_src  :none
    policy.script_src  :self
    policy.style_src   :self
    policy.connect_src :self
    policy.base_uri    :self
    policy.form_action :self
    policy.frame_ancestors :none
  end

  # Nonce для можливих inline script/style у Rails helpers.
  config.content_security_policy_nonce_generator = ->(request) {
    request.session.id.presence || SecureRandom.base64(16)
  }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end

