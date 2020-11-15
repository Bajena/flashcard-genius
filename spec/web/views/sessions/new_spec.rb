RSpec.describe Web::Views::Sessions::New, type: :view do
  let(:exposures) { Hash[format: :html, current_user: nil, flash: {}, params: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/sessions/new.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders correctly" do
    expect { rendered }.not_to raise_error
  end
end
