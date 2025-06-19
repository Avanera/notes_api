module ApiHelpers
  def json_response
    JSON.parse(response.body)
  end

  def expect_json_response(expected_keys = [])
    expect(response.content_type).to include('application/json')
    expected_keys.each do |key|
      expect(json_response).to have_key(key.to_s)
    end
  end
end
