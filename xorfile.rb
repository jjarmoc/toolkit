#!/usr/bin/ruby

require 'optparse'
#require 'pry'

def xorstring(string, key, increment = false)
	if increment
		#increment mode adds the offset of each byte to the xor key 
		string.length.times {|n| 
			begin 
				#binding.pry if (key[n.modulo key.size].ord + n > 257)
				string[n] = (string[n].ord ^ ((key[n.modulo key.size].ord + n )% 255)).chr 
			rescue => e
				puts "!! Exception #{e.message}"
				#binding.pry
			end
		}
	else
		string.length.times {|n| string[n] = (string[n].ord ^ key[n.modulo key.size].ord).chr }
	end
	return string
end

def hex_to_bin(s)
  s.scan(/../).map { |x| x.hex.chr }.join
end

def bin_to_hex(s)
  s.each_byte.map { |b| b.to_s(16) }.join
end

options = {}

optparse = OptionParser.new do|opts|
	opts.banner = "Usage: xorfile.rb [options] file1 file2 ..."

	options[:key] = "\x00"
	opts.on( '-k', '--key KEY', 'xor using KEY (in hex, no prefix)' ) do|key|
		options[:key] = hex_to_bin(key)
	end

	options[:outext] = "xor"
    opts.on( '-x', '--outext EXT', 'append EXT to output file' ) do|ext|
    	options[:outext] = ext
    end

    options[:increment] = false
    opts.on( '-i', '--increment', 'increment XOR key for each byte') do
    	options[:increment] = true
    end
end

optparse.parse!
puts "- XOR'ing with #{options[:key]}"
puts "- Incrementing key for each byte" if options[:increment]

ARGV.each { |file|
	puts "> Processing #{file}... to #{file}.#{options[:outext]}"

	infile = File.open("#{file}","rb")
	input = infile.read
	infile.close

	outfile = File.open("#{file}.#{options[:outext]}",'w')
	outfile.write(xorstring(input, "#{options[:key]}", options[:increment]))
    
}

#input = ')C-E$G*I/K>M`O>Q=SyU?W(Yt[3],_\aabc'

outfile = File.open("#{file}.#{options[:outext]}",'w')
outfile.write(xorstring(input, "#{options[:key]}", options[:increment]))
    
puts "Input: #{input}"
puts "Output: " + xorstring(input, options[:key], options[:increment])

puts "- DONE"
