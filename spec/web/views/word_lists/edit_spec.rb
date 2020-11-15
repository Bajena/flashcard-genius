RSpec.describe Web::Views::WordLists::Edit, type: :view do
  let(:exposures) { Hash[format: :html, current_user: current_user, word_list: word_list, params: params, flash: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/word_lists/edit.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:current_user) { build(:user) }
  let(:word_list) { create(:word_list, name: "Great list") }
  let(:params) do
    instance_double(Hanami::Action::Params, valid?: true)
  end

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders list input" do
    expect(rendered).to include("value=\"Great list\"")
  end

  it "doesn't show error messages" do
    expect(rendered).not_to include("There was a problem with your submission")
  end
end
