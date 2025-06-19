require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:title).is_at_most(255) }
  end

  describe 'scopes' do
    let!(:active_note) { create(:note) }
    let!(:archived_note) { create(:note, :archived) }

    describe '.archived' do
      it 'returns only archived notes' do
        expect(Note.archived).to include(archived_note)
        expect(Note.archived).not_to include(active_note)
      end
    end

    describe '.active' do
      it 'returns only active notes' do
        expect(Note.active).to include(active_note)
        expect(Note.active).not_to include(archived_note)
      end
    end
  end
end
