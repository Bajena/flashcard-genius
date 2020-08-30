RSpec.describe Web::Controllers::Users::Create, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { { user: user_params } }
  let(:user_params) do
    {
      email: email,
      password: password
    }
  end
  let(:email) { "signup@example.com" }
  let(:password) { "Test1234" }
  let(:session) { {} }
  let!(:user) { create(:user) }
  let(:exposed_user) { action.exposures[:user] }
  let(:errors) { action.exposures[:error_messages] }
  let(:created_user) do
    UserRepository.
      new.
      users.
      order { created_at.desc }.
      limit(1).
      first
  end

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    it "redirects to word lists index" do
      expect do
        expect(response).to redirect_to("/word_lists")
      end.not_to change { UserRepository.new.all.count }
    end
  end

  context "when signup succeeds" do
    it "sets current user and redirects" do
      expect do
        expect(response).to redirect_to("/word_lists")
      end.to change { UserRepository.new.all.count }.by(1)

      expect(action.session[:user_id]).to eq(created_user.id)
      expect(created_user.email).to eq(email)
    end
  end

  context "when signup fails" do
    let(:email) { "invalid" }

    it "renders errors" do
      expect do
        expect(response[0]).to eq(422)
      end.not_to change { UserRepository.new.all.count }

      expect(errors).to eq(["Email is in invalid format"])
      expect(exposed_user).to be_a(User)
      expect(exposed_user.email).to eq(nil)
    end
  end
end
