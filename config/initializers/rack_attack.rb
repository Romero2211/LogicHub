# frozen_string_literal: true

# Rate limiting через rack-attack.
# Лічильники зберігаються в Rails.cache:
#   development → memory_store
#   production  → solid_cache_store
#
# Важливо: шляхи мають збігатися з config/routes.rb.

class Rack::Attack
  ### Safelist ###
  # Health-check балансувальника не повинен потрапляти під throttle.
  safelist("allow-healthcheck") do |req|
    req.path == "/up"
  end

  ### Throttles ###

  # Brute-force логіну: 5 POST /login з одного IP за хвилину.
  throttle("login/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/login" && req.post?
  end

  # Масова реєстрація: 5 POST /users з одного IP за годину.
  throttle("signup/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.path == "/users" && req.post?
  end

  # Спам постів: 10 POST /posts з одного IP за годину.
  # (не чіпаємо GET /posts і вкладені шляхи на кшталт /posts/1/comments)
  throttle("posts/ip", limit: 10, period: 1.hour) do |req|
    req.ip if req.path == "/posts" && req.post?
  end

  # Спам коментарів: 10 POST /posts/:id/comments з одного IP за хвилину.
  # РАНІШЕ було req.path == "/comments" — це НІКОЛИ не спрацьовувало,
  # бо nested route створює коментар як POST /posts/:post_id/comments.
  throttle("comments/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.post? && req.path.match?(%r{\A/posts/\d+/comments\z})
  end

  # Спам лайків (пости + коментарі): 60 запитів з IP за хвилину.
  throttle("likes/ip", limit: 60, period: 1.minute) do |req|
    if (req.post? || req.delete?) && req.path.match?(%r{\A/(posts|comments)/\d+/like\z})
      req.ip
    end
  end

  ### Custom 429 response ###
  self.throttled_responder = lambda do |req|
    match = req.env["rack.attack.match_data"] || {}
    period = match[:period]
    retry_after = period.is_a?(Integer) ? period.to_s : "60"

    body = {
      error: "too_many_requests",
      message: "Слишком много запросов. Подождите немного и попробуйте снова."
    }.to_json

    [
      429,
      {
        "Content-Type" => "application/json; charset=utf-8",
        "Retry-After" => retry_after
      },
      [body]
    ]
  end
end
