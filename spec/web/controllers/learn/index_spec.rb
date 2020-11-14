RSpec.describe Web::Controllers::Learn::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) do
    {
      'rack.session' => session,
      'router.params' => router_params
    }
  end
  let(:router_params) { { word_list_id: word_list_id } }
  let(:response) { action.call(params) }
  let(:user) { create(:user) }
  let(:session) { { user_id: user.id } }
  let(:word_list) do
    create(:word_list, user_id: user.id)
  end
  let(:word_list_id) { word_list.id }

  context "when user is not logged in" do
    let(:session) { {} }

    it 'redirects to login' do
      expect(response).to redirect_to("/login")
    end
  end

  it "exposes word_list_id" do
    expect(response[0]).to eq 200

    expect(action.exposures[:word_list_id]).to eq(word_list.id)
  end
end
