task reset: :environment do

  puts 'Destroying books...'
  Book.destroy_all

  puts ''

  puts 'Creating books...'
  Dir[Rails.root + 'db/seeds/books/*.yml'].each do |path|
    data = YAML.load_file(path).deep_symbolize_keys!.merge! icon: File.new(Rails.root + "db/seeds/books/icons/#{File.basename path, '.yml'}.svg")

    puts "  Creating \"#{data[:title]}\"..."
    book = Book.create data.except(:chapters)

    puts '    Creating chapters...'
    Chapter.create data[:chapters]&.map{ |chapter| chapter.merge! book: book } || []

    puts ''
  end

  puts ''

  puts 'Destroying users...'
  User.destroy_all

  puts ''

  puts 'Creating default user'

  user = User.create(
    pseudo: 'circe',
    email: 'circe.grand@mail.com',
    password: 'heyheyhey',
    password_confirmation: 'heyheyhey',
    tutorial_done: true
  )

  puts '  Creating default user avatar'

  Avatar.create(
    user_id: user.id,
    face: :oval,
    skin: :fair,
    eyes: :semicircles,
    mouth: :long_semicircle,
    haircut: :long_straight,
    accessory: :hairclip,
    sweater: :green
  )

  puts 'Finished.'
end
