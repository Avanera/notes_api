require 'rails_helper'

RSpec.describe NoteBlueprint do
  let(:note) { create(:note) }

  describe 'default view' do
    let(:result) { described_class.render_as_hash(note, view: :default) }

    it 'includes basic fields' do
      expect(result).to include(:id, :title, :archived, :created_at)
      expect(result).not_to include(:body, :updated_at)
    end
  end

  describe 'detailed view' do
    let(:result) { described_class.render_as_hash(note, view: :detailed) }

    it 'includes all fields' do
      expect(result).to include(:id, :title, :body, :archived, :created_at, :updated_at)
    end
  end
end
