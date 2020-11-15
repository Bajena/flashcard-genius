RSpec.describe Web::Views::Donate::Index, type: :view do
  let(:exposures) { Hash[format: :html, current_user: build(:user), flash: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/donate/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders correctly" do
    expect { rendered }.not_to raise_error
  end
end
