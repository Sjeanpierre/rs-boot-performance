#!/usr/bin/env ruby


$script_names = []
$script_durations = []
$name_strings_to_remove = %w(*RS> **** RightScript:)
$duration_timestamp_regex = Regexp.new(/\d.:\d\d.\d\d./)
$duration_strings_to_remove = %w(Script duration:)



# Will receive single line containing name and strip out known trash
def extract_script_name(line)
  script_name = line.split.delete_if {|line_part|$name_strings_to_remove.include?(line_part)}.join(' ').delete("'")
  $script_names.push(script_name)
end

# Will receive single line containing duration and strip out known trash
def extract_script_duration(line)
  script_duration = line.split.delete_if {|line_part| $duration_strings_to_remove.include?(line_part)}.delete_if {|line_part| line_part.match($duration_timestamp_regex)}.join(' ')
  $script_durations.push(script_duration)
end

def loop_through_file(filename)
  script_name_regex = Regexp.new('RightScript:')
  script_duration_regex = Regexp.new('Script duration:')
  skip_start = Regexp.new('======== redis::default : START ========')
  skip_end = Regexp.new('======== redis::default : END ========')
  in_skip_block = false
  filename.each_line do |line|
    in_skip_block = true if line.match(skip_start)
    in_skip_block = false if line.match(skip_end)
    next if in_skip_block
    if line.match(script_name_regex)
      extract_script_name(line)
    elsif line.match(script_duration_regex)
      extract_script_duration(line)
    end
  end
end



def process_audit(contents)
  loop_through_file(contents)
  Hash[*$script_names.zip($script_durations).flatten]
end


