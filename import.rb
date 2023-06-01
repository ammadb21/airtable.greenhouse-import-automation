#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'lib/greenhouse'
require_relative 'lib/airtable'
require_relative 'lib/helpers'

# DAF ID= 1384008
# ITALS ID= 1479435
# FLE ID= 1479432
# ENG ID= 1387643
# SPA ID= 1387638

jobs_id = %w[1384008 1479435 1479432 1387643 1387638]

def applications(job_id)
  greenhouse = Greenhouse.new
  airtable = Airtable.new(ENV['AIRTABLE_HIRING_URL'])
  since_yesterday = (Time.now - 86_400).to_time.iso8601

  results = greenhouse.applications(job_id, since_yesterday)
  results.each do |result|
    analise = RecordAnaliser.new(result)
    candidate = greenhouse.get_candidate(result['candidate_id'])
    payload = {
      "records": [
        {
          "fields": {
            "Full name": "#{candidate['first_name']} #{candidate['last_name']}",
            "Language": analise.job(result['jobs'][0]['id'].to_s),
            "Email": candidate['email_addresses'][0]['value'],
            "Freelance": analise.freelancer?,
            "Possible Start copy": analise.start?,
            "Availability 30h/month": analise.fulltime?,
            "Experience as an online teacher": analise.experience?,
            "Location / Country copy": (result['location']['address'].split(', ')[-1] unless result['location'].nil?),
            "Applied via": 'Greenhouse',
            "Attachments": analise.attachments
          }
        }
      ]
    }
    airtable.create_record(payload)
  end
end

jobs_id.each { |job_id| applications(job_id) }
