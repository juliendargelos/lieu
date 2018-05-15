puts 'Destroying books...'
Book.destroy_all

puts ''

puts 'Creating books...'
Dir[Rails.root + 'db/seeds/books/*.yml'].each do |path|
  data = YAML.load_file(path).deep_symbolize_keys!.merge! icon: File.new(Rails.root + "db/seeds/books/icons/#{File.basename path, '.yml'}.svg")

  puts "  Creating \"#{data[:title]}\"..."
  book = Book.create data.except(:chapters)

  puts "    Creating chapters..."
  Chapter.create data[:chapters]&.map{ |chapter| chapter.merge! book: book } || []

  puts ''
end

if Rails.env.development?
  puts 'Destroying users...'
  User.destroy_all

  puts ''

  data = [
    {
      pseudo: :juliendargelos,
      email: 'julien.dargelos@me.com',
      password: :juliendargelos,
      password_confirmation: :juliendargelos
    },
    {
      pseudo: :circe,
      email: 'circegrand@gmail.com',
      password: :motdepasse,
      password_confirmation: :motdepasse
    }
  ]

  puts 'Creating users...'
  User.create data

  data.each do |user|
    puts "  Pseudo: #{user[:pseudo]}"
    puts "  Password: #{user[:password]}"

    puts ''
  end
end

puts 'Finished.'
