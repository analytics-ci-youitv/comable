describe Comable::ApplicationHelper do
  subject { helper }

  describe '#liquidize' do
    it 'returns liquidized string' do
      string = 'John'
      expect(subject.liquidize('Name: {{ name }}', name: string)).to include(string)
    end

    it 'allows the specified method of a model to liquidize' do
      order = build(:order, total_price: 100)
      expect(subject.liquidize('Total price: {{ order.total_price }}', order: order)).to include(order.total_price.to_s)
    end

    it 'denies the specified method of a model to liquidize' do
      order = build(:order, email: 'john@example.com')
      expect(subject.liquidize('email: {{ order.email }}', order: order)).not_to include(order.email)
    end
  end

  describe '#liquid_assigns' do
    let(:dummy_controller) { ActionController::Base.new }

    before do
      allow(subject).to receive(:current_store).and_return(nil)
      allow(subject).to receive(:current_comable_user).and_return(nil)
      allow(subject).to receive(:current_order).and_return(nil)
      allow(subject).to receive(:current_trackers).and_return([])
      allow(subject).to receive(:form_authenticity_token).and_return('__form_authenticity_token__')

      dummy_controller.instance_variable_set(:@dummy, 'Dummy Value')

      controller = dummy_controller
      subject.singleton_class.send(:define_method, :view_context) { controller.view_context }
    end

    after do
      subject.singleton_class.send(:remove_method, :view_context)
    end

    it 'returns the hash that included assigns of view context' do
      expect(subject.liquid_assigns).to include('dummy' => dummy_controller.instance_variable_get(:@dummy))
    end

    it 'returns the hash that included additional assigns' do
      expect(subject.liquid_assigns.keys).to include(*%w( current_store current_comable_user current_order current_trackers form_authenticity_token ))
    end
  end
end
