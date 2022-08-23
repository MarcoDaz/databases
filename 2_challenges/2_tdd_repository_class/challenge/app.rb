require_relative 'lib/database_connection'
require_relative 'lib/book_repository'

DatabaseConnection.connect('book_store')
repo = BookRepository.new

repo.all.each do |book|
  puts "#{book.id} - #{book.title} - #{book.author_name}"
end