# frozen_string_literal: true

# Record analiser
class RecordAnaliser
  def initialize(record)
    @record = record
  end

  def attachments
    attachments = ''
    @record['attachments'].each { |attach| attachments += "[#{attach['filename'].gsub('_', '')}](#{attach['url']})\n" }
    attachments
  end

  def freelancer?
    is_freelance = nil
    @record['answers'].each do |answer|
      is_freelance = true if answer['question'] == 'Freelance status ' && answer['answer'] == 'Yes'
    end
    is_freelance
  end

  def experience?
    has_experience = nil
    @record['answers'].each do |answer|
      has_experience = answer['answer'] if answer['question'] == 'Online experience '
    end
    has_experience
  end

  def start?
    can_start = nil
    @record['answers'].each do |answer|
      can_start = answer['answer'] if answer['question'] == 'What is your earliest start date?'
    end
    can_start
  end

  def fulltime?
    fulltime = nil
    @record['answers'].each do |answer|
      fulltime = true if answer['question'] == 'Are you available to teach at least 30 hours per month?'
    end
    fulltime
  end

  def job(job)
    jobs = {
      '1384008' => 'German (DAF)',
      '1479432' => 'French (FLE)',
      '1479435' => 'Italian (DITALS)',
      '1387638' => 'Spanish (ELE)',
      '1387643' => 'English (ESL)'
    }
    jobs[job]
  end
end
