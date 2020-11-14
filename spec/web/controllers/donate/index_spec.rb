RSpec.describe Web::Controllers::Donate::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { {} }
  let(:session) { {} }
  let(:response) { action.call(params) }

  context "when user is logged in" do
    let(:user) { create(:user) }
    let(:session) { { user_id: user.id } }

    it 'is successful' do
      response = action.call(params)
      expect(response[0]).to eq 200
    end
  end

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end
end
