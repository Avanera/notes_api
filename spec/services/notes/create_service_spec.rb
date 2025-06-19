require 'rails_helper'

RSpec.describe Notes::CreateService do
  describe '.call' do
    context 'with valid params' do
      let(:params) { { title: 'Test Note', body: 'Test body' } }

      it 'creates a new note' do
        expect {
          described_class.call(params: params)
        }.to change(Note, :count).by(1)
      end

      it 'returns success result' do
        result = described_class.call(params: params)

        expect(result.success?).to be(true)
        note = Note.last
        expect(result.data).to eq({
          id: note.id,
          archived: note.archived,
          body: note.body,
          created_at: note.created_at,
          title: 'Test Note',
          updated_at: note.updated_at
        })
      end
    end

    context 'with invalid params' do
      let(:params) { { title: '', body: '' } }

      it 'does not create a note' do
        expect {
          described_class.call(params: params)
        }.not_to change(Note, :count)
      end

      it 'returns failure result with errors' do
        result = described_class.call(params: params)

        expect(result.success?).to be(false)
        expect(result.errors).to be_present
      end
    end
  end
end
