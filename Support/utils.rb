# Format snippet
# This assumes one "thing" is happening per comment
class String
  def parse_snippet_comments
    groupStarted = false

    # Split on block/inline comments, capture with regex
    self.split(/(?:\/\*\s*(.+?)\s*\*\/|\/\/\s*([\S]+))\n?/mx).each_slice(2).map do |slices|
      line, comment = slices

      # Escape line if we're in a group
      if groupStarted and line and line != ''
        line.gsub!(/([}])/) {|c| "\\#{c}"}
      end

      # Escape special characters
      line.gsub!(/([`$])/) {|c| "\\#{c}"}

      # group starts and ends in a single line
      if /\$\{\d+\:.+?\}/m.match(comment)
        # nested group
        # if groupStarted

      # start of a group
      elsif /\$\{\d+\:/.match(comment)
        groupStarted = true

      # end of a group
      elsif comment == '}'
        groupStarted = false
      end

      "#{line}#{comment}"
    end.join("")
  end
end
