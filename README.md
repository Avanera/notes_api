
# Notes API

REST API для управления заметками с интеграцией AI для обработки текста.

## Особенности

- **CRUD операции** для заметок
- **Пагинация** с метаданными
- **AI интеграция** для переписывания текста в разных стилях (не реализовано)
- **Архивирование** заметок
- **Swagger документация**
- **Комплексное тестирование** с RSpec
- **Service Objects** для бизнес-логики
- **Сериализация** через Blueprinter

## Технологии

- Ruby 3.2.2
- Rails 8.0
- SQLite3
- RSpec для тестирования
- Swagger/OpenAPI документация

## Установка

### Установка Ruby

Версию Ruby можно узнать из файла .ruby-version в корне проекта.

**С использованием RVM:**

Установите RVM:

    \curl -sSL https://get.rvm.io | bash

Установите нужную версию Ruby:

    rvm install "$(cat .ruby-version)"

Используйте эту версию Ruby по умолчанию:

    rvm use "$(cat .ruby-version)" --default

### Установка Redis ([Официальное руководство](http://redis.io/topics/quickstart))

    brew install redis

Затем запустите его в фоновом режиме, следуя инструкциям в программе установки:

    brew services start redis

или 

    redis-server

Проверьте, что Redis работает:

    redis-cli ping

Должен быть получен ответ: Pong


### Установка зависимостей проекта

Клонируйте репозиторий:

    git clone git@github.com:Avanera/notes_api.git

Установите Bundler (если ещё не установлен):

    gem install bundler

Установите зависимости:

    bundle install

Скопируйте файл `.env.development` в корневую папку, переименуйте его в `.env.development.local` - в него должны быть добавлены все «настоящие» переменные ENV.

**Предупреждение:** Ваши коммиты не должны содержать никаких конфиденциальных данных. Именно поэтому файлы `.env.development.local` и `.env.test.local` игнорируются гитом.
Более подробную информацию смотрите на сайте https://github.com/bkeepers/dotenv.


### Настройка базы данных

Создайте и наполните базу данных:

    rails db:reset

Это удалит, пересоздаст и заполнит базу данных.

# Генерация Swagger документации из тестов

    rake rswag:specs:swaggerize

Это создаст файл Swagger (например, swagger/v1/swagger.json), который содержит описание операций API.


## Запуск

    rails server

API будет доступно по адресу: `http://localhost:3000`
Swagger документация: `http://localhost:3000/api-docs`

## Тестирование

    bundle exec rspec

## API Endpoints

В дополнение к Swagger документации, ниже представлен краткий обзор доступных конечных точек API.

- `GET /api/v1/notes` - получить список заметок
- `POST /api/v1/notes` - создать заметку
- `GET /api/v1/notes/:id` - получить заметку
- `PATCH /api/v1/notes/:id` - обновить заметку
- `DELETE /api/v1/notes/:id` - удалить заметку
- `PATCH /api/v1/notes/:id/rewrite` - переписать текст через AI (не реализовано)

## Примеры запросов

### Создание заметки
```bash
curl -X POST http://localhost:3000/api/v1/notes \
  -H "Content-Type: application/json" \
  -d '{
    "note": {
      "title": "Моя заметка",
      "body": "Содержание заметки"
    }
  }'
```

### Фильтрация и поиск
```bash
# Получить архивированные заметки
curl "http://localhost:3000/api/v1/notes?archived=true"

# Пагинация
curl "http://localhost:3000/api/v1/notes?page=1&per_page=10"
```

### AI переписывание (не реализовано)
```bash
curl -X PATCH http://localhost:3000/api/v1/notes/1/rewrite \
  -H "Content-Type: application/json" \
  -d '{"rewrite_mode": "polite"}'
```

AI переписывание будет реализовано с помощью фоновых задач.
Sidekiq::Web — это веб-интерфейс для мониторинга фоновых задач, который доступен по адресу http://localhost:3000/sidekiq

## Архитектурные решения и выбор инструментов

Бизнес-логика вынесена из контроллера в Service Objects.

Blueprinter для сериализации.

Состояния через AASM - отслеживание статуса обработки заметки.

Комплексное тестирование:
- Unit тесты для моделей и сервисов
- Request тесты для API
- Swagger (integration) тесты для документации

## Безопасность

- Валидация входящих данных
- Стандартизированная обработка ошибок
- Strong parameters
- Dotenv для хранения секретов

## Развертывание

Для production рекомендуется:
- Использовать PostgreSQL вместо SQLite
- Настроить мониторинг и логирование

## TODO:
- реализовать безопасность: (CORS, Rack Attack)
- доделать AI интеграцию.
- реализовать асинхронные запросы к AI.
- написать тесты на AI интеграцию.
