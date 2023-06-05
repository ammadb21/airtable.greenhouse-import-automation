#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'lib/greenhouse'
require_relative 'lib/airtable'
require_relative 'lib/analyser'
require 'logger'

logger = Logger.new($stdout)
logger.formatter = proc do |severity, datetime, progname, msg|
  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
  "[#{date_format}] #{severity}: (greenhouse-import) #{msg}#{progname}\n"
end

# DAF ID= 1384008
# ITALS ID= 1479435
# FLE ID= 1479432
# ENG ID= 1387643
# SPA ID= 1387638

job_ids = %w[1384008 1479435 1479432 1387643 1387638]

def applications(job_id, logger)
  greenhouse = Greenhouse.new
  airtable = Airtable.new(ENV['AIRTABLE_HIRING_URL'])
  since_yesterday = (Time.now - 86_400).to_time.iso8601

  results = greenhouse.applications(job_id, since_yesterday)
  results.each do |result|
    analyse = RecordAnalyser.new(result)
    candidate = greenhouse.get_candidate(result['candidate_id'])
    payload = {
      "records": [
        {
          "fields": {
            "Full name": "#{candidate['first_name']} #{candidate['last_name']}",
            "Language": analyse.job,
            "Email": candidate['email_addresses'][0]['value'],
            "Freelance": analyse.freelancer?,
            "Possible Start (greenhouse)": analyse.start,
            "Availability 30h/month": analyse.fulltime?,
            "Experience as an online teacher": analyse.experience,
            "Location / Country (greenhouse)": analyse.country,
            "Applied via": 'Greenhouse',
            "Attachments": analyse.attachments
          }
        }
      ]
    }
    airtable.create_record(payload)
    logger.info "✅ Imported an applicant for #{analyse.job}!"
  end
end

job_ids.each { |job_id| applications(job_id, logger) }
