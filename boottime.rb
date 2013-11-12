#!/usr/bin/env ruby

class BootTimer

  NAME_STRINGS_TO_REMOVE = %w(*RS> **** RightScript:)
  DURATION_STRINGS_TO_REMOVE = %w(Script duration:)
  DURATION_TIMESTAMP_REGEX = Regexp.new(/\d.:\d\d.\d\d./)
  SCRIPT_NAME_REGEX = Regexp.new('RightScript:')
  SCRIPT_DURATION_REGEX = Regexp.new('Script duration:')
  BEGIN_SKIP_REGEX = Regexp.new('======== redis::default : START ========')
  END_SKIP_REGEX = Regexp.new('======== redis::default : END ========')

  def initialize(data)
    @script_names = []
    @script_durations = []
    @data = data
  end

  def process
    in_skip_block = false
    @data.each_line do |line|
      in_skip_block = true if line.match(BEGIN_SKIP_REGEX)
      in_skip_block = false if line.match(END_SKIP_REGEX)
      next if in_skip_block
      if line.match(SCRIPT_NAME_REGEX)
        extract_script_name(line)
      elsif line.match(SCRIPT_DURATION_REGEX)
        extract_script_duration(line)
      end
    end
    #noinspection RubyHashKeysTypesInspection
    Hash[*@script_names.zip(@script_durations).flatten]
  end

  # Will receive single line containing name and strip out known trash
  def extract_script_name(line)
    script_name = line.split.delete_if { |line_part| NAME_STRINGS_TO_REMOVE.include?(line_part) }.join(' ').delete("'")
    @script_names.push(script_name)
  end

  # Will receive single line containing duration and strip out known trash
  def extract_script_duration(line)
    script_duration = line.split.delete_if { |line_part| DURATION_STRINGS_TO_REMOVE.include?(line_part) }.delete_if { |line_part| line_part.match(DURATION_TIMESTAMP_REGEX) }.join(' ')
    @script_durations.push(script_duration)
  end

end


