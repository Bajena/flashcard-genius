RSpec.describe Web::Controllers::Google::Callback, type: :action do
  let(:action) { described_class.new }
  let(:params) { { 'omniauth.auth' => auth_params } }
  let(:response) { action.call(params) }
  let(:auth_params) do
    {
      "info" => {
        "email" => auth_email
      }
    }
  end
  let(:auth_email) { "pedro@flashcard-genius.com" }
  let(:flash) { action.exposures[:flash] }

  context "when auth hash doesn't include email" do
    let(:auth_params) { {} }

    it "redirects to login path" do
      response

      expect(flash[:error]).not_to be_nil
      expect(response).to redirect_to("/login")
      expect(action.session[:user_id]).to eq(nil)
    end
  end

  context "when user exists" do
    let!(:user) { create(:user, email: auth_email) }

    it "logs him in and redirects to root" do
      expect(response).to redirect_to("/")
      expect(action.session[:user_id]).to eq(user.id)
    end
  end

  context "when user doesn't exist" do
    let!(:user) { create(:user, email: "other@email.com") }
    let(:created_user) do
      UserRepository.
        new.
        users.
        order { created_at.desc }.
        limit(1).
        first
    end

    it "creates a user with random password and redirects to root" do
      expect do
        response
      end.to change { UserRepository.new.all.count }.by(1)

      expect(created_user.email).to eq(auth_email)
      expect(response).to redirect_to("/")
      expect(action.session[:user_id]).to eq(created_user.id)
    end
  end
end
