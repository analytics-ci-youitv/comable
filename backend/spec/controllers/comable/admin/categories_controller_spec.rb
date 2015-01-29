describe Comable::Admin::CategoriesController do
  let(:comable) { controller.comable }

  describe 'GET index' do
    it 'assigns all categories as @categories' do
      category = FactoryGirl.create(:category)
      get :index
      expect(assigns(:categories)).to eq([category])
    end
  end

  # TODO: Add tests for 'create'
end
