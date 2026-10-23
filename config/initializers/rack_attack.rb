class Rack::Attack
  throttle("login/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/login" && req.post?
  end

  throttle("comments/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.path == "/comments" && req.post?
  end
end
