RSpec.describe Web::Views::Words::Create, type: :view do
  let(:exposures) { Hash[format: :html, current_user: current_user, word: word, word_list: word_list, params: params, flash: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/words/create.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:current_user) { create(:user) }
  let(:word_list) do
    create(:word_list, user_id: user_id, name: "Great list")
  end
  let(:word) { create(:word, question: "QText", word_list_id: word_list.id) }
  let(:user_id) { current_user.id }
  let(:params) do
    instance_double(Hanami::Action::Params, dig: nil, valid?: valid, error_messages: error_messages)
  end
  let(:valid) { true }
  let(:error_messages) { [] }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  context "when list belongs to current user" do
    let(:user_id) { nil }

    it "displays the word" do
      expect(rendered).to include("flashcard-content")
      expect(rendered).to include("QText")
    end
  end

  context "when there are errors" do
    let(:valid) { false }
    let(:error_messages) { ["Question must be present"] }

    it "doesn't display the word and displays the errors" do
      expect(rendered).not_to include("flashcard-content")
      expect(rendered).to include("There was a problem with your submission:")
      expect(rendered).to include("Question must be present")
    end
  end
end
