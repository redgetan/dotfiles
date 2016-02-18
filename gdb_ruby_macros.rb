ruby_source_dir = ARGV[0]

lines = Dir["#{ruby_source_dir}/**/*.c",
            "#{ruby_source_dir}/**/*.h"]
        .reject { |filename| filename.include? "enc/trans/" }
        .map    { |filename| File.read(filename).split("\n") }
        .flatten

macros = []

lines.each_with_index do |line, index|
  offset = 0

  if line =~ /^#define/
    macro = line

    while lines[index + offset] =~ /\\$/
      offset += 1
      macro_next_line = lines[index + offset].prepend("\n")
      macro.concat(macro_next_line)
    end

    macros << macro
  end

end

gdb_macros = macros.map do |macro|
  macro.gsub /^#/, "macro "
end

puts gdb_macros
