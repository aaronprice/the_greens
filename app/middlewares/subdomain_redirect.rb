class SubdomainRedirect
  def initialize(app)
    @app = app
  end

  def is_non_asset_request?(request_mime_types, request_url)
    return false if request_mime_types.blank?
    return false if request_url.blank?

    request_mime_types.include?("text/html") && request_url.path !~ /^\/(assets|system)\/.+$/
  end

  def request_url_with_subdomain(url)
    query     = url.query.present? ? "?#{url.query}" : nil
    fragment  = url.fragment.present? ? "##{url.fragment}" : nil
    request_url_with_subdomain = "#{url.scheme}://www.#{url.host}#{url.path}#{query}#{fragment}"
  end

  def request_url_subdomain_blank?(url)
    "#{url.host}".downcase.split('.')[-3].blank?
  end

  def call(env)
    request             = Rack::Request.new(env)
    request_url         = URI.parse(request.try(:url).to_s.downcase)
    request_mime_types  = env["HTTP_ACCEPT"]

    if is_non_asset_request?(request_mime_types, request_url) && request_url_subdomain_blank?(request_url)
      redirect_url = request_url_with_subdomain(request_url)
      [301, { "Location" => redirect_url, "Content-Type" => "text/html" }, ["You are being redirected to #{redirect_url}"]]
    else
      @app.call(env)
    end
  end

end