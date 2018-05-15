puts 'Creating books...'
Dir[Rails.root + 'db/seeds/books/*.yml'].each do |path|
  data = YAML.load_file(path).deep_symbolize_keys!.merge! icon: File.new(Rails.root + "db/seeds/books/icons/#{File.basename path, '.yml'}.svg")

  puts "  Creating \"#{data[:title]}\"..."
  book = Book.create data.except(:chapters)

  puts "    Creating chapters..."
  Chapter.create data[:chapters]&.map{ |chapter| chapter.merge! book: book } || []

  puts ''
end

puts 'Finished.'
