describe Comable::StockLocation do
  it { is_expected.to have_many(:shipments).class_name(Comable::Shipment.name) }
  it { is_expected.to have_many(:stocks).class_name(Comable::Stock.name).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
end
