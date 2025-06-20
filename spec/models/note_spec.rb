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

  describe 'aasm rewrite_status state machine' do
    let(:note) { create(:note) }

    it 'has initial state :original' do
      expect(note).to have_state(:original)
    end

    describe '#start_rewriting' do
      it 'transitions from :original to :rewriting' do
        expect(note).to transition_from(:original).to(:rewriting).on_event(:start_rewriting)
      end

      it 'transitions from :rewrite_failed to :rewriting' do
        note.update!(rewrite_status: :rewrite_failed)
        expect(note).to transition_from(:rewrite_failed).to(:rewriting).on_event(:start_rewriting)
      end
    end

    describe '#complete_rewriting' do
      it 'transitions from :rewriting to :rewritten' do
        note.update!(rewrite_status: :rewriting)
        expect(note).to transition_from(:rewriting).to(:rewritten).on_event(:complete_rewriting)
      end
    end

    describe '#fail_rewriting' do
      it 'transitions from :rewriting to :rewrite_failed' do
        note.update!(rewrite_status: :rewriting)
        expect(note).to transition_from(:rewriting).to(:rewrite_failed).on_event(:fail_rewriting)
      end
    end
  end
end
