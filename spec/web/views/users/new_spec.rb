RSpec.describe Web::Views::Users::New, type: :view do
  let(:exposures) { Hash[format: :html, user: User.new, error_messages: error_messages, current_user: nil, flash: {}, params: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/users/new.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:error_messages) { [] }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders correctly" do
    expect { rendered }.not_to raise_error
    expect(rendered).not_to include("There was a problem with your submission:")
  end

  context "when error_messages is present" do
    let(:error_messages) { ["Email must be present"] }

    it "renders errors" do
      expect(rendered).to include("There was a problem with your submission:")
      expect(rendered).to include("Email must be present")
    end
  end
end
