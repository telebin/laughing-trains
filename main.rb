#!/bin/ruby

if ARGV.size.zero?
  puts 'Needs argument: input file'
  exit 1
end

INPUT_FILE = $ARGV[0]
if File::size(INPUT_FILE) > 2 << 25
  puts 'Insane input size'
  exit 2
end

input = File::read INPUT_FILE
m = 'mapa okolic'
loc = '(?:\p{Word}|\s)+?'
opt_date = '(?:(?:\s?\d\d\.?){3})?'
time = '\d\d?:\d\d'
locations = "#{m}\\s+(?<start>#{loc})\\n#{m}\\s+(?<stop>#{loc})#{opt_date}"
times = "(?<dep>#{time})\\s+(?<arr>#{time})\\s+(?<time>#{time})"
regex = /#{locations}\n[^\d]+#{times}.*$/

match = regex.match input
