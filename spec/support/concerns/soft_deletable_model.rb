RSpec.shared_examples 'soft_deletable_model' do
  let(:model) { described_class }
  let(:deleted) { create(described_class.name.underscore.to_sym, :deleted) }
  let(:visible) { create(described_class.name.underscore.to_sym) }

  describe '.visible' do
    it 'returns the objects which have not been deleted yet' do
      expect(described_class.visible).to include(visible)
    end
  end

  describe '.deleted' do
    it 'returns the objects which have been deleted' do
      expect(described_class.deleted).to include(deleted)
    end
  end

  describe '#deleted?' do
    context 'when object has not been deleted' do
      it 'returns false' do
        expect(visible).not_to be_deleted
      end
    end

    context 'when object has been deleted' do
      it 'returns true' do
        expect(deleted).to be_deleted
      end
    end
  end

  describe '#visible?' do
    context 'when object has been deleted' do
      it 'returns false' do
        expect(deleted).not_to be_visible
      end
    end

    context 'when object has not been deleted' do
      it 'returns true' do
        expect(visible).to be_visible
      end
    end
  end

  describe '#soft_destroy' do
    context 'when object has been deleted' do
      subject { deleted.soft_destroy }

      it 'does not make any changes to object' do
        expect { subject }.not_to change { deleted.deleted_at }
      end

      it 'returns false' do
        expect(subject).to be_falsy
      end
    end

    context 'when object has not been deleted' do
      subject { visible.soft_destroy }

      it 'update the deleted_at field' do
        expect { subject }.to change { visible.deleted_at }
      end

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe '#recover' do
    context 'when object has not been deleted' do
      subject { visible.recover }

      it 'does not make any changes' do
        expect { subject }.not_to change { visible.deleted_at }
      end

      it 'returns false' do
        expect(subject).to be_falsy
      end
    end

    context 'when object has been deleted' do
      subject { deleted.recover }

      it 'sets the deleted_at to nil' do
        expect { subject }.to change { deleted.deleted_at }.to(nil)
      end

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end
end
