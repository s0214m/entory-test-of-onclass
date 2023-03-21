FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    due_date { Faker::Date.between(from: '2023-04-01', to: '2023-12-31') }
    completed { Faker::Boolean.boolean }
  end
end
