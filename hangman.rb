def get_words
  File.open('words').map{|w|w.strip}
end

def add_word(word)
  word.strip!
  words = get_words
  if words.include? word
    puts "#{word} is in the list"
    return
  end
  File.open('words','a') do |l|
    l.puts word
  end
  puts "added #{word} to the dictionary"
end

def suggest_letter(words, used_letters, pattern)
  if used_letters.empty?
    regex = /^\w{#{pattern.size}}$/
  else
    not_letters = "[^#{used_letters.join}]"
    regex = Regexp.new("^#{pattern.gsub('_',not_letters)}$")
  end
  matching_words = words.select{|w|w =~ regex}

  suggestions = {}
  (('a'..'z').to_a-used_letters).each do |letter|
    suggestions[letter] = matching_words.count{|w|w.chars.include? letter}
  end
  suggestions.max_by(4){|_,count|count}.each do |letter,count|
    puts "#{letter} is present in #{count} known words"
  end
end

def new_game(letters)
  words = get_words
  used_letters = []
  pattern = '_'*letters.to_i
  suggest_letter(words, used_letters, pattern)
  while true
    puts "\nEnter a bad letter or new pattern"
    input = gets.strip
    if input.size == 1
      used_letters << input
    elsif input.strip == 'done'
      return
    else #i__i__i_
      pattern = input
      chars = input.chars
      chars.delete('_')
      used_letters = (chars + used_letters).uniq
    end
    suggest_letter(words, used_letters, pattern)
  end
end

def add_record(level)
  level = level.strip.to_i
  if level == 0
    'That\'s not a real number, idiot'
    return
  end
  current_record = File.read('record').strip.to_i
  if current_record > level
    puts "The current record is #{current_record}"
  else
    File.open('record','w'){|f| f.puts level}
    puts "#{level} is a new record!"
  end
end

while true
  puts 'Type \'new\' to start a new word, \'add\' to add a word or \'quit\' to quit or \'record\' to update record'

  command = gets.strip.split
  case command[0]
  when 'new'
    new_game(command[1].to_i)
  when 'add'
    add_word(command[1])
  when 'quit'
    exit
  when 'record'
    add_record(command[1])
  end
end