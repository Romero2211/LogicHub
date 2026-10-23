# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
roman = User.find_or_create_by!(email: "roman@logichub.test") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

alex = User.find_or_create_by!(email: "alex@logichub.test") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

posts_data = [
  {
    title: "Логическая ошибка в Interstellar?",
    body: "На планете Миллер время течёт иначе, но подготовка миссии это почти не учитывает. Как команда могла так спланировать высадку?",
    category: :movies,
    source_url: "https://www.imdb.com/title/tt0816692/",
    user: roman
  },
  {
    title: "Странное поведение в сериале «Тьма»",
    body: "Некоторые персонажи знают слишком много о петлях времени, но всё равно повторяют одни и те же ошибки. Это замысел или дыра в логике?",
    category: :series,
    user: alex
  },
  {
    title: "Почему главный герой в RPG никогда не устаёт?",
    body: "В большинстве игр персонаж несёт тонны лута и сражается часами без сна. Какие вселенные это хотя бы пытаются объяснить?",
    category: :games,
    user: roman
  },
  {
    title: "Может ли ИИ понимать собственные ответы?",
    body: "Модель уверенно формулирует вывод, даже когда внутри нет понимания. Где проходит граница между языком и смыслом?",
    category: :ai,
    user: alex
  }
]

posts = posts_data.map do |attrs|
  Post.find_or_create_by!(title: attrs[:title]) do |post|
    post.body = attrs[:body]
    post.category = attrs[:category]
    post.source_url = attrs[:source_url]
    post.user = attrs[:user]
  end
end

Comment.find_or_create_by!(body: "Отличное наблюдение про гравитацию и время.", user: alex, post: posts[0])
Comment.find_or_create_by!(body: "Кажется, это сознательный ход сценаристов.", user: roman, post: posts[1])
Comment.find_or_create_by!(body: "В некоторых симуляторах усталость всё же есть.", user: alex, post: posts[2])
Comment.find_or_create_by!(body: "Модель предсказывает токены, а не «понимает».", user: roman, post: posts[3])

Like.find_or_create_by!(user: alex, likeable: posts[0])
Like.find_or_create_by!(user: roman, likeable: posts[3])
Like.find_or_create_by!(user: roman, likeable: Comment.find_by!(body: "Отличное наблюдение про гравитацию и время."))
Like.find_or_create_by!(user: alex, likeable: Comment.find_by!(body: "Модель предсказывает токены, а не «понимает»."))

puts "Users: #{User.count}, Posts: #{Post.count}, Comments: #{Comment.count}, Likes: #{Like.count}"
