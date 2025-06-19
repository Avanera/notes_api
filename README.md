
# Notes API

REST API для управления заметками с интеграцией AI для обработки текста.

## Особенности

- **CRUD операции** для заметок
- **Пагинация** с метаданными
- **AI интеграция** для переписывания текста в разных стилях
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

```bash
git clone [repository-url]
cd notes-api
bundle install
rails db:create db:migrate
rails db:seed
```

## Запуск

```bash
rails server
```

API будет доступно по адресу: `http://localhost:3000`
Swagger документация: `http://localhost:3000/api-docs`

## API Endpoints

### Заметки

- `GET /api/v1/notes` - получить список заметок
  - Параметры: `page`, `per_page`, `archived`, `q[title_cont]`
- `POST /api/v1/notes` - создать заметку
- `GET /api/v1/notes/:id` - получить заметку
- `PUT/PATCH /api/v1/notes/:id` - обновить заметку
- `DELETE /api/v1/notes/:id` - удалить заметку

### Специальные операции

- `PATCH /api/v1/notes/:id/archive` - архивировать заметку
- `PATCH /api/v1/notes/:id/unarchive` - разархивировать заметку
- `PATCH /api/v1/notes/:id/rewrite` - переписать текст через AI
  - Параметр: `rewrite_mode` (polite, cheerful, mysterious)

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

# Поиск по заголовку
curl "http://localhost:3000/api/v1/notes?q[title_cont]=test"

# Пагинация
curl "http://localhost:3000/api/v1/notes?page=1&per_page=10"
```

### AI переписывание
```bash
curl -X PATCH http://localhost:3000/api/v1/notes/1/rewrite \
  -H "Content-Type: application/json" \
  -d '{"rewrite_mode": "polite"}'
```

## Тестирование

```bash
# Запуск всех тестов
bundle exec rspec

# Запуск конкретного теста
bundle exec rspec spec/models/note_spec.rb

# Запуск интеграционных тестов
bundle exec rspec spec/requests/

# Генерация Swagger документации из тестов
bundle exec rspec spec/integration/notes_spec.rb --format RswagSpecs::JsonFormatter --order defined
```

## Структура проекта

```
app/
├── controllers/
│   ├── application_controller.rb
│   └── api/v1/notes_controller.rb
├── models/
│   └── note.rb
├── services/
│   ├── application_service.rb
│   ├── ai_rewrite_service.rb
│   └── notes/
│       ├── create_service.rb
│       ├── update_service.rb
│       ├── destroy_service.rb
│       ├── index_service.rb
│       ├── archive_service.rb
│       ├── unarchive_service.rb
│       └── rewrite_service.rb
└── blueprints/
    └── note_blueprint.rb

spec/
├── models/
├── requests/
├── services/
├── blueprints/
└── integration/ (Swagger тесты)
```

## Архитектурные решения

### Service Objects
Бизнес-логика вынесена в Service Objects для:
- Лучшей тестируемости
- Переиспользования кода
- Разделения ответственности

### Blueprinter для сериализации
- Гибкая сериализация с разными view
- Производительность
- Простота использования

### Комплексное тестирование
- Unit тесты для моделей и сервисов
- Integration тесты для API
- Swagger тесты для документации

## Rate Limiting

API включает ограничения на количество запросов:
- 300 запросов за 5 минут на IP
- 100 API запросов в минуту на IP

## Безопасность

- Валидация всех входящих данных
- Стандартизированная обработка ошибок
- CORS настройки
- Rate limiting
- Strong parameters

## Мониторинг

- Structured logging готов к подключению
- Health check endpoint: `/up`
- Метрики производительности в логах

## Развертывание

Приложение готово к развертыванию на любой платформе, поддерживающей Rails:
- Heroku
- Docker
- AWS/Google Cloud
- VPS

Для production рекомендуется:
- Использовать PostgreSQL вместо SQLite
- Настроить Redis для кэширования
- Подключить реальный AI сервис
- Настроить мониторинг и логирование
