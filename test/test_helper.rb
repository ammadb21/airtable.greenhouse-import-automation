#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/airtable'
require_relative '../lib/greenhouse'
require 'test/unit'

# Airtable Tests
class AirtableCalls < Test::Unit::TestCase
  def test_airtable_onboard_get
    airtable_onboard = Airtable.new(ENV['AIRTABLE_HIRING_URL'])
    response = airtable_onboard.get
    assert(response.success?)
  end
end

# Greenhouse Tests
class GreenHouseCalls < Test::Unit::TestCase
  def test_greenhouse_applications_get
    greenhouse = Greenhouse.new
    today = Time.now.to_time.iso8601
    job = '1384008'
    response = greenhouse.applications(job, today)
    assert(response.success?)
  end
end
