# LogicHub

Платформа для обговорення логічних нестиковок, теорій і спостережень про фільми, серіали, ігри та ШІ.

**THINK. QUESTION. DISCUSS.**

## Можливості

- Публікація постів за категоріями: фільми, серіали, ігри, ШІ
- Коментарі до постів
- Лайки постів і коментарів (без перезавантаження сторінки)
- Пошук і сортування (нові / старі / обговорювані / за лайками)
- Зображення в постах (Active Storage)
- Авторизація через email + пароль
- Темна тема (Tailwind CSS)
- Пагінація (Pagy)

Гості можуть лише читати. Редагувати й видаляти контент може лише автор.

## Стек

| Технологія | Версія / примітка |
|---|---|
| Ruby | 3.2+ |
| Rails | 8.1 |
| SQLite | розробка |
| Tailwind CSS | через `tailwindcss-rails` |
| Hotwire | Turbo + Stimulus |
| Pagy | пагінація |
| bcrypt | `has_secure_password` |

## Встановлення

```bash
git clone https://github.com/Romero2211/LogicHub.git
cd LogicHub
bundle install
bin/rails db:prepare
bin/rails db:seed
```

## Запуск

Рекомендовано через `bin/dev` (сервер + збірка Tailwind):

```bash
bin/dev
```

Або окремо:

```bash
bin/rails server
bin/rails tailwindcss:watch
```

Додаток: [http://127.0.0.1:3000](http://127.0.0.1:3000)

## Тестові акаунти (після seed)

| Email | Пароль |
|---|---|
| `roman@logichub.test` | `password123` |
| `alex@logichub.test` | `password123` |

## Структура

```
app/
  controllers/   # posts, comments, likes, categories, sessions, users
  models/        # User, Post, Comment, Like
  views/         # ERB + Tailwind
  javascript/    # Stimulus (превʼю зображень), Turbo
db/
  migrate/
  seeds.rb
```

## Ліцензія

Навчальний / особистий проєкт.
