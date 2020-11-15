RSpec.describe Web::Views::WordLists::Index, type: :view do
  let(:exposures) { Hash[format: :html, current_user: current_user, word_lists: word_lists, params: params, flash: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/word_lists/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:current_user) { build(:user) }
  let(:word_lists) do
    [
      {
        id: 1,
        name: "list 1",
        word_count: 1,
        created_at: DateTime.now
      },
      {
        id: 2,
        name: "list 2",
        word_count: 1,
        created_at: DateTime.now
      }
    ]
  end
  let(:params) do
    instance_double(Hanami::Action::Params, valid?: true)
  end

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders lists" do
    expect(rendered).to include("list 1")
    expect(rendered).to include("list 2")
  end
end
