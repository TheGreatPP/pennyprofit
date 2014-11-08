module RouteSupport

  def success_response(body, code: 200, headers: {})
    body = body.to_json
    halt(code, headers, body)
  end

  def handle_error_response(error, code: 500)
    halt(code, {}, error_response(error.to_s))
  end

  private

  def error_response(msg)
    {
      message: msg
    }.to_json
  end
end
