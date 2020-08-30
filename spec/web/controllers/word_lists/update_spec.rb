RSpec.describe Web::Controllers::WordLists::Update, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) do
    query_params.merge(
      'rack.session' => session,
      'router.params' => router_params
    )
  end
  let(:router_params) do
    {
      id: word_list_id,
      word_list: word_list_params
    }
  end
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
  let(:word_list_id) { word_list.id }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:word_list) { create(:word_list, :with_words, user_id: word_list_user_id) }
  let(:word_list_user_id) { user.id }
  let!(:other_user_word_list) { create(:word_list, user_id: other_user.id) }
  let(:exposed_list) { action.exposures[:word_list] }
  let(:updated_list) do
    reload_list
  end

  def reload_list
    WordListRepository.new.find_with_words(word_list.id)
  end

  context "when list with given id doesn't exist" do
    let(:word_list_id) { SecureRandom.uuid }

    it "renders 404" do
      expect(response[0]).to eq 404
    end
  end

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    context "when list belongs to another user" do
      let(:word_list_id) { other_user_word_list.id }

      it "renders 404" do
        expect(response[0]).to eq 404
      end
    end

    context "when list is anonymous" do
      let(:word_list_user_id) { nil }

      it "updates the list and words" do
        expect(response[0]).to eq 302
        expect(updated_list.user_id).to eq(nil)
        expect(updated_list.name).to eq(name)
        expect(updated_list.words.length).to eq(2)
        expect(updated_list.words[0].question).to eq("Boy")
        expect(updated_list.words[0].question_example).to eq("That boy is tall")
        expect(updated_list.words[0].answer).to eq("Ragazzo")
        expect(updated_list.words[0].answer_example).to eq("Questo ragazzo é alto")
        expect(updated_list.words[1].question).to eq("Girl")
        expect(updated_list.words[1].question_example).to eq(nil)
        expect(updated_list.words[1].answer).to eq("Ragazza")
        expect(updated_list.words[1].answer_example).to eq(nil)
      end

      context "when params include user_id" do
        it "doesn't update the user_id" do
          expect(response[0]).to eq 302
          expect(updated_list.user_id).to eq(nil)
        end
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
          end.not_to change { reload_list.updated_at }

          expect(exposed_list.name).to eq(name)
          expect(exposed_list.words[0].question).to eq("Boy")
          expect(updated_list.name).to eq("A list")
          expect(updated_list.words[0].question).to eq("Polska")
          expect(action.params.error_messages).to eq(["Answer is missing"])
        end
      end
    end

    context "when list belongs to the user" do
      it "updates the list and words" do
        expect(response[0]).to eq 302
        expect(updated_list.user_id).to eq(user.id)
        expect(updated_list.name).to eq(name)
        expect(updated_list.words.length).to eq(2)
      end
    end
  end

  context "when user isn't logged in" do
    context "when list belongs to a user" do
      it "renders 404" do
        expect(response[0]).to eq 404
      end
    end

    context "when list is anonymous" do
      let(:word_list_user_id) { nil }

      it "updates the list and words" do
        expect(response[0]).to eq 302
        expect(updated_list.user_id).to eq(nil)
        expect(updated_list.name).to eq(name)
        expect(updated_list.words.length).to eq(2)
      end
    end
  end
end
