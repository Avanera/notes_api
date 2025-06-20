FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence(word_count: 3) }
    body { Faker::Lorem.paragraph(sentence_count: 5) }
    archived { false }
    rewrite_status { :original }
    rewrite_error { nil }

    trait :archived do
      archived { true }
    end
  end
end
