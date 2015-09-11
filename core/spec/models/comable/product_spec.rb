describe Comable::Product do
  it { is_expected.to have_many(:variants).class_name(Comable::Variant.name) }
  it { is_expected.to have_many(:images).class_name(Comable::Image.name) }
  it { is_expected.to have_and_belong_to_many(:categories).class_name(Comable::Category.name) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }

  describe '.published' do
    it 'includes published products' do
      product = create(:product, published_at: Time.now)
      expect(described_class.published).to include(product)
    end

    it 'excludes unpublished products' do
      product = create(:product, published_at: nil)
      expect(described_class.published).not_to include(product)
    end
  end

  describe '#published?' do
    subject { build(:product) }

    it 'should be false when published_at is nil' do
      subject.published_at = nil
      expect(subject.published?).to be false
    end

    it 'should be false when published_at greater than now' do
      subject.published_at = 1.minute.since
      expect(subject.published?).to be false
    end

    it 'should be true when published_at equal now' do
      subject.published_at = Time.now
      expect(subject.published?).to be true
    end

    it 'should be true when published_at less than now' do
      subject.published_at = 1.minute.ago
      expect(subject.published?).to be true
    end
  end
end
