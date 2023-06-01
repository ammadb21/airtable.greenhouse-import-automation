# frozen_string_literal: true

require 'json'
require 'httparty'

# Airtable API Calls
class Airtable
  include HTTParty
  base_uri 'https://api.airtable.com/v0'
  headers 'Content-Type' => 'application/json'
  headers 'Authorization' => "Bearer #{ENV['AIRTABLE_API_TOKEN']}"

  def initialize(airtable_url)
    @airtable_url = airtable_url
  end

  def get
    response = self.class.get(@airtable_url)
    abort("❌ Error in Airtable::get => #{response}") unless response.success?
    response
  end

  def create_record(payload)
    response = self.class.post(@airtable_url, "body": JSON.dump(payload))
    abort("❌ Error in Airtable::add_note => #{response}") unless response.success?
    response
  end
end
