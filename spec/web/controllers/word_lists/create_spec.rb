RSpec.describe Web::Controllers::WordLists::Create, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { { word_list: word_list_params } }
  let(:word_list_params) do
    {
      name: name,
      words: words
    }
  end
  let(:name) { "My list" }
  let(:words) do
    [
      {
        question: "Boy",
        question_example: "That boy is tall",
        answer: "Ragazzo",
        answer_example: "Questo ragazzo é alto"
      },
      {
        question: "Girl",
        answer: "Ragazza"
      }
    ]
  end
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:exposed_list) { action.exposures[:word_list] }
  let(:created_list) do
    WordListRepository.
      new.
      aggregate(:words).
      order(created_at: :desc).
      word_lists.
      map_to(WordList).
      one
  end

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    it "creates the list with words" do
      expect do
        expect(response[0]).to eq 302
      end.to change { WordListRepository.new.all.count }.by(1)
      expect(created_list.user_id).to eq(user.id)
      expect(created_list.name).to eq(name)
      expect(created_list.words.length).to eq(2)
      expect(created_list.words[0].question).to eq("Boy")
      expect(created_list.words[0].question_example).to eq("That boy is tall")
      expect(created_list.words[0].answer).to eq("Ragazzo")
      expect(created_list.words[0].answer_example).to eq("Questo ragazzo é alto")
      expect(created_list.words[1].question).to eq("Girl")
      expect(created_list.words[1].question_example).to eq(nil)
      expect(created_list.words[1].answer).to eq("Ragazza")
      expect(created_list.words[1].answer_example).to eq(nil)
    end

    context "when list is invalid" do
      let(:words) do
        [
          {
            question: "Boy"
          }
        ]
      end

      it "exposes the list and renders errors" do
        expect do
          expect(response[0]).to eq 422
        end.not_to change { WordListRepository.new.all.count }

        expect(exposed_list.name).to eq(name)
        expect(action.params.error_messages).to eq(["Answer is missing"])
      end
    end
  end

  context "when user isn't logged in" do
    it "creates an anonymous list with words" do
      expect do
        expect(response[0]).to eq 302
      end.to change { WordListRepository.new.all.count }.by(1)
      expect(created_list.user_id).to eq(nil)
      expect(created_list.name).to eq(name)
      expect(created_list.words.length).to eq(2)
    end
  end
end
