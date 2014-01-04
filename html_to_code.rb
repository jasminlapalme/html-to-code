require "html_compressor"
require 'optparse'
 
options = {}
optparse = OptionParser.new do|opts|
	opts.banner = "Usage: html_to_code.rb [options] file"

	options[:cars_per_line] = 10
	opts.on( '-c', '--cars_per_line N', Integer, 'Number of characters to write on one line' ) do |n|
		options[:cars_per_line] = n
	end

	options[:name] = nil
	opts.on( '-n', '--name NAME', 'Name of the array' ) do |name|
		options[:name] = name
	end

	options[:arduino] = false
	opts.on( '-a', '--arduino', 'Create an arduino friendly array (PROGMEM)' ) do
		options[:arduino] = true
	end

	options[:output] = nil
	opts.on( '-o', '--output FILE', 'Write the output to FILE' ) do |file|
		options[:output] = file
	end

	opts.on( '-h', '--help', 'Display this screen' ) do
		$stderr.puts opts
		exit
	end
end

optparse.parse!

if options[:name] == nil and options[:output] == nil
	$stderr.puts "Either a name or an output file must be specified"
	$stderr.puts optparse
	exit 1
end

options[:name] = File.basename(options[:output]) if options[:output]

output = options[:output] ? File.open(options[:output], "w") : $stdout

compressor = HtmlCompressor::HtmlCompressor.new({ "compress_css" => true })
mini_html = compressor.compress(ARGF)

output.write "const char #{options[:name]}[] "
output.write "PROGMEM " if options[:arduino]
output.write "= {"

cars_per_line = options[:cars_per_line]

mini_html.each_byte.each_with_index do |c, i|
	if (i % cars_per_line) == 0
		output.write " /* #{mini_html[i-cars_per_line..i]} */" if i > 0
		output.write "\n "
	end
	output.write " 0x#{c.to_s(16)},"
end

output.write " 0x00 };"

rest = mini_html.length % cars_per_line
if rest > 0
	output.write " /* #{mini_html[mini_html.length-rest..mini_html.length]} */"
end
output.write "\n"
