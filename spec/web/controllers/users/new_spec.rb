RSpec.describe Web::Controllers::Users::New, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:response) { action.call(params) }

  it 'renders the view' do
    expect(response[0]).to eq(200)
    expect(action.exposures[:user]).to eq(User.new)
    expect(action.exposures[:error_messages]).to eq([])
  end
end
