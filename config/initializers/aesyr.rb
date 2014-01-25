# There's not much going on with groups in discourse and I don't feel like 
# fucking with the database at this stage, so:
#
# Since group names aren't displayed anywhere currently, the user title is
# part of the name, double-semicolon-separated:
#
# group_name;;position;;<b>Fancy Title</b>
#
# The more complex styling is in the aesyr plugin.

module UserTitles
  module InstanceMethods
    def title
      puts 'slerp'
      @title ||= read_attribute(:title)
      @group_titles ||= groups.collect(&:name).collect{|n|
        parts = n.split(';;')
        puts parts.inspect
        parts.size > 2 ? [parts[1].to_i, parts[2]] : nil
      }.reject{|n| n.nil?}.sort.collect{|n|n[1]} || []

      # no <br/> - styling in aesyr plugin
      ([@title] + @group_titles).join
    end
  end
end

User.send(:include, UserTitles::InstanceMethods)

# Disable the lazy 15 character group name validator using UsernameValidator
Group;class Group
  def name_format_validator; end
end
