require 'factory_bot_rails'

Note.destroy_all

10.times do
  FactoryBot.create(:note)
end

10.times do
  FactoryBot.create(:note, :archived)
end
