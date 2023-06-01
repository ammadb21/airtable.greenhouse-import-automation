# frozen_string_literal: true

require 'httparty'
require 'base64'

# Greenhouse API Calls
class Greenhouse
  include HTTParty
  base_uri 'https://harvest.greenhouse.io/v1'
  headers 'Content-Type' => 'application/json'
  headers 'Authorization' => "Basic #{Base64.encode64("#{ENV['GREENHOUSE_API_TOKEN']}: ").delete!("\n")}"

  def applications(job, time)
    query = {
      'created_after' => time,
      'job_id' => job
    }
    response = self.class.get('/applications', query: query)
    abort("❌ Error in Greenhouse::get_applications => #{response}") unless response.success?
    response
  end

  def get_candidate(candidate)
    response = self.class.get("/candidates/#{candidate}")
    abort("❌ Error in Greenhouse::get_candidate => #{response}") unless response.success?
    response
  end
end
