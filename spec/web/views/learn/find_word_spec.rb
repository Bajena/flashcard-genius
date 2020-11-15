RSpec.describe Web::Views::Learn::FindWord, type: :view do
  let(:exposures) do
    {
      format: :html,
      word: word,
      word_list: word_list,
      last_test_at: last_test_at,
      params: {}
    }
  end
  let(:template)  { Hanami::View::Template.new('apps/web/templates/learn/find_word.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:word) { create(:word) }
  let(:word_list) { create(:word_list) }
  let(:last_test_at) { DateTime.now.to_s }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it "renders the word" do
    expect(rendered).to include("Question")
    expect(rendered).to include("Answer")
    expect(rendered).to include("Previously checked at:")
    expect(rendered).to include("List:")
  end

  context "when last_test_at is empty" do
    let(:last_test_at) { nil }

    it "doesn't render the last checked section" do
      expect(rendered).to include("Question")
      expect(rendered).to include("Answer")
      expect(rendered).not_to include("Previously checked at:")
    end
  end

  context "when word is not present" do
    let(:word) { nil }

    it "renders finished text" do
      expect(rendered).to include("You're all set for now!")
    end
  end
end
