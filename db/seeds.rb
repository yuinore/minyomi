# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# !!!!DANGER!!!!
Choice.destroy_all
Word.destroy_all
Vote.destroy_all

word_linux = Word.create!(name: 'Linux', slug: 'linux', tags: '#Linux #OS')
word_constexpr = Word.create!(name: 'constexpr', slug: 'constexpr', tags: '#C言語 #C++')

Choice.create!(name: 'コンストイーエクスピーアール', count: 21, auth_count: 8, word: word_constexpr)
Choice.create!(name: 'コンストエクスプレ', count: 9, auth_count: 7, word: word_constexpr)
Choice.create!(name: 'コンストエクスプル', count: 1, auth_count: 0, word: word_constexpr)

choice1 = Choice.create!(name: 'リナックス', count: 3, auth_count: 0, word: word_linux)
choice2 = Choice.create!(name: 'リヌックス', count: 2, auth_count: 0, word: word_linux)

Vote.create!(choice: choice1, authenticated: false, user: nil, session: 'XXXX0001')
Vote.create!(choice: choice1, authenticated: false, user: nil, session: 'XXXX0002')
Vote.create!(choice: choice1, authenticated: false, user: nil, session: 'XXXX0003')
Vote.create!(choice: choice2, authenticated: false, user: nil, session: 'XXXX0004')
Vote.create!(choice: choice2, authenticated: false, user: nil, session: 'XXXX0005')
