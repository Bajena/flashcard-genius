RSpec.describe Web::Controllers::Home::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { {} }
  let(:session) { {} }
  let(:response) { action.call(params) }

  context "when user is logged in" do
    let(:user) { create(:user) }
    let(:session) { { user_id: user.id } }

    it 'redirects to word lists' do
      expect(response).to redirect_to("/word_lists")
    end
  end

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end
end
