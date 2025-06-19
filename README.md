
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

### Установка Ruby

Проект использует Ruby. Версию можно узнать из файла .ruby-version в корне проекта.

**С использованием RVM:**

Установите RVM:
    \curl -sSL https://get.rvm.io | bash

Установите нужную версию Ruby:

    rvm install "$(cat .ruby-version)"

Используйте эту версию Ruby по умолчанию:

    rvm use "$(cat .ruby-version)" --default

### Установка зависимостей проекта

Клонируйте репозиторий:

    git clone git@github.com:Avanera/notes_api.git

Установите Bundler (если ещё не установлен):

    gem install bundler

Установите зависимости:

    bundle install


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
- `PATCH /api/v1/notes/:id/rewrite` - переписать текст через AI

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

### AI переписывание
```bash
curl -X PATCH http://localhost:3000/api/v1/notes/1/rewrite \
  -H "Content-Type: application/json" \
  -d '{"rewrite_mode": "polite"}'
```

## Архитектурные решения и выбор инструментов

### Service Objects
Бизнес-логика вынесена из контроллера в Service Objects для:
- Лучшей тестируемости
- Переиспользования кода
- Разделения ответственности

### Blueprinter для сериализации
- Гибкая сериализация
- Производительность
- Простота использования

### Комплексное тестирование
- Unit тесты для моделей и сервисов
- Integration тесты для API
- Swagger тесты для документации

<!-- ## Rate Limiting

API включает ограничения на количество запросов:
- 300 запросов за 5 минут на IP
- 100 API запросов в минуту на IP -->

## Безопасность

- Валидация входящих данных
- Стандартизированная обработка ошибок
<!-- - CORS настройки -->
<!-- - Rate limiting -->
- Strong parameters

<!-- ## Мониторинг

- Structured logging готов к подключению
- Health check endpoint: `/up`
- Метрики производительности в логах -->

## Развертывание

Для production рекомендуется:
- Использовать PostgreSQL вместо SQLite
- Подключить реальный AI сервис
- Настроить мониторинг и логирование
