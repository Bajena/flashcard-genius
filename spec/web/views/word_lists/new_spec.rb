RSpec.describe Web::Views::WordLists::New, type: :view do
  let(:exposures) { Hash[format: :html, current_user: current_user, word_list: word_list, params: params, flash: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/word_lists/new.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:current_user) { build(:user) }
  let(:word_list) { build(:word_list) }
  let(:params) do
    instance_double(Hanami::Action::Params, valid?: true)
  end

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders correct privacy info" do
    expect(rendered).to include("for viewing to anyone with a link")
  end

  it "doesn't show error messages" do
    expect(rendered).not_to include("There was a problem with your submission")
  end

  context "when user is not present" do
    let(:current_user) { nil }

    it "renders correct privacy info" do
      expect(rendered).to include("for viewing/editing to anyone with a link")
    end
  end
end
