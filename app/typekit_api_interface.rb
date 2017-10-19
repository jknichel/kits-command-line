require 'rest-client'

module TypekitApiInterface
  API_URL_BASE = 'https://typekit.com/api/v1/json/'
  AUTH_KEY_HEADER = 'X-Typekit-Token'

  # This class simply wraps the Typekit API. It provides methods that take in 
  # the required fields to construct a valid API request, send the request, and
  # then return the response.
  class TypekitApiWrapper
    def initialize(key)
      @request_header = {AUTH_KEY_HEADER => key}
    end

    # First, a method for making requests with RestClient. It requires the 
    # specification of a method (GET, POST, DELETE), the endpoint to access,
    # and an optional payload for POST requests.
    def make_request(method, endpoint, payload={})
      params = ["#{API_URL_BASE}/#{endpoint}", payload, @request_header]
      begin
        JSON.parse RestClient.send(method.to_sym, *params.reject { |p| p.empty? })
      rescue RestClient::Exception => e
        return { "error" => e.message }
      end
    end

    # The below methods make requests to the Typekit API endpoints and return
    # hashes from the parsed JSON responses. The methods that make POST requests
    # take in a JSON string and parse them for RestClient.
    def list_kits
      resp = make_request :get, "kits"
      check_response_for_field resp, "kits"
    end

    def kit_info(id)
      resp = make_request :get, "kits/#{id}"
      check_response_for_field resp, "kit"
    end

    def create_kit(json)
      payload = JSON.parse(json)
      resp = make_request :post, "kits", payload
      check_response_for_field resp, "kit"
    end

    def update_kit(id, json)
      payload = JSON.parse(json)
      resp = make_request :post, "kits/#{id}", payload
      check_response_for_field resp, "kit"
    end

    def delete_kit(id)
      resp = make_request :delete, "kits/#{id}"
      check_response_for_field resp, "ok"
    end

    # Check if the expected field is present. If it is, return the response.
    # If the field isn't present, and it isn't an error response, then raise
    # an exception.
    def check_response_for_field(resp, field_name)
      if resp[field_name].nil? && resp['error'].nil?
        raise MissingExpectedFieldError
      end
      resp
    end
  end

  class MissingExpectedFieldError < StandardError
    def initialize(msg="The response from the endpoint is missing an expected value!")
      super(msg)
    end
  end
end
