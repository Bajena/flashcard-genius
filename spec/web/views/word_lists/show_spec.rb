RSpec.describe Web::Views::WordLists::Show, type: :view do
  let(:exposures) { Hash[format: :html, current_user: current_user, word_list: word_list, params: params, flash: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/word_lists/show.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:current_user) { create(:user) }
  let(:word_list) do
    l = create(:word_list, :with_words, word_count: 2, user_id: user_id, name: "Great list")
    WordListRepository.new.find_with_words(l.id)
  end
  let(:user_id) { current_user.id }
  let(:params) do
    instance_double(Hanami::Action::Params, dig: nil)
  end

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  context "when list belongs to current user" do
    let(:user_id) { nil }

    it "displays all actions apart from learn" do
      expect(rendered).to include("Print this list")
      expect(rendered).to include("+ Add a word")
      expect(rendered).not_to include("Learn this list")
      expect(rendered).to include("Edit list")
      expect(rendered).to include("Delete list")
      expect(rendered).to include("Edit card")
      expect(rendered).to include("delete-word-form")
    end
  end

  context "when user is unlogged" do
    let(:current_user) { nil }
    let(:user_id) { create(:user).id }

    it "does not display edit actions" do
      expect(rendered).to include("Print this list")
      expect(rendered).not_to include("+ Add a word")
      expect(rendered).not_to include("Learn this list")
      expect(rendered).not_to include("Edit list")
      expect(rendered).not_to include("Delete list")
      expect(rendered).not_to include("Edit card")
      expect(rendered).not_to include("delete-word-form")
    end
  end

  context "when list is anonymous" do
    let(:user_id) { nil }

    it "displays all actions apart from learn" do
      expect(rendered).to include("Print this list")
      expect(rendered).to include("+ Add a word")
      expect(rendered).not_to include("Learn this list")
      expect(rendered).to include("Edit list")
      expect(rendered).to include("Delete list")
      expect(rendered).to include("Edit card")
      expect(rendered).to include("delete-word-form")
    end
  end

  context "when list belongs to another user" do
    let(:user_id) { create(:user).id }

    it "does not display edit actions" do
      expect(rendered).to include("Print this list")
      expect(rendered).not_to include("+ Add a word")
      expect(rendered).not_to include("Learn this list")
      expect(rendered).not_to include("Edit list")
      expect(rendered).not_to include("Delete list")
      expect(rendered).not_to include("Edit card")
      expect(rendered).not_to include("delete-word-form")
    end
  end
end
