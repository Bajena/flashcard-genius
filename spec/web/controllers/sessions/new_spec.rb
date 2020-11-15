RSpec.describe Web::Controllers::Sessions::New, type: :action do
  let(:action) { described_class.new }
  let(:params) do
    {
      'rack.session' => session
    }
  end
  let(:response) { action.call(params) }
  let(:user) { create(:user) }
  let(:session) { { user_id: user.id } }

  context "when user is not logged in" do
    let(:session) { {} }

    it 'renders the view' do
      expect(response[0]).to eq(200)
      expect(action.exposures[:user]).to eq(User.new)
      expect(action.exposures[:error_messages]).to eq([])
    end
  end

  context "when user is logged in" do
    it 'redirects to word lists' do
      expect(response).to redirect_to("/word_lists")
    end
  end
end
