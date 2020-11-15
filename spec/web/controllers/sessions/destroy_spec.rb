RSpec.describe Web::Controllers::Sessions::Destroy, type: :action do
  let(:action) { described_class.new }
  let(:params) do
    {
      'rack.session' => session
    }
  end
  let(:session) { { user_id: 1 } }
  let(:response) { action.call(params) }

  it 'clears session and redirects to login' do
    response

    expect(action.session[:user_id]).to eq(nil)
    expect(response).to redirect_to("/login")
  end
end
