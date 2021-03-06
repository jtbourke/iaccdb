# manage list of participants
# translates name to IAC member
# result of manual match-up
module ACRO
class ParticipantList
  LIST_NAME = 'participant_list.yml'

  class Participant
    attr_accessor :db_id
    attr_accessor :given_name
    attr_accessor :family_name
    attr_accessor :iac_id

    def initialize(member)
      @db_id = member['id']
      @given_name = member['given_name']
      @family_name = member['family_name']
      @iac_id = member['iac_id']
    end
  end

  def initialize
    @list = {}
  end

  def add(name, member)
    if member
      part = Participant::new(member)
    else
      part = 'nil'
    end
    @list[name] = part
  end

  def write(data_directory)
    File.open(File.join(data_directory, LIST_NAME), 'w') do |f|
      f << @list.to_yaml
    end
  end

  def read(data_directory)
    @list = YAML.load_file(File.join(data_directory, LIST_NAME))
  end

  def participant(name)
    part = @list[name]
    if part == 'nil'
      part = nil
    end
    part
  end

end
end
