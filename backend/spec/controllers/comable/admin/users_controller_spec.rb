describe Comable::Admin::UsersController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }
  let(:invalid_attributes) { valid_attributes.merge(email: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all users as @users' do
      user = FactoryGirl.create(:user)
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      user = FactoryGirl.create(:user)
      get :show, id: user.to_param
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested user as @user' do
      user = FactoryGirl.create(:user)
      get :edit, id: user.to_param
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PUT update' do
    let!(:user) { FactoryGirl.create(:user) }

    describe 'with valid params' do
      let(:new_attributes) { { email: "new_#{user.email}" } }

      it 'updates the requested user' do
        put :update, id: user.to_param, user: new_attributes
        user.reload
        expect(user).to have_attributes(new_attributes)
      end

      it 'assigns the requested user as @user' do
        put :update, id: user.to_param, user: valid_attributes
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        put :update, id: user.to_param, user: valid_attributes
        expect(response).to redirect_to([comable, :admin, user])
      end
    end

    describe 'with invalid params' do
      it 'assigns the user as @user' do
        put :update, id: user.to_param, user: invalid_attributes
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        put :update, id: user.to_param, user: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end
end
