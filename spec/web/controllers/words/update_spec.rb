RSpec.describe Web::Controllers::Words::Update, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge('router.params' => query_params) }
  let(:query_params) do
    {
      id: word_id,
      word: word_params
    }
  end
  let(:word_params) do
    {
      question: "A",
      answer: "B",
      question_example: "C",
      answer_example: "D"
    }
  end
  let(:word_id) { word.id }
  let(:session) { {} }
  let(:user) { create(:user) }
  let!(:word) { create(:word, user_id: user.id, word_list_id: word_list.id) }
  let(:word_list) { create(:word_list, user_id: word_list_user_id) }
  let(:word_list_user_id) { user.id }
  let(:updated_word) { WordRepository.new.find(word.id) }

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    context "when word doesn't exist" do
      let(:word_id) { word.id + 1 }

      it "renders 404" do
        expect(response[0]).to eq 404
      end
    end

    context "when word list is anonymous" do
      let(:word_list_user_id) { nil }

      it "updates the word and word tests" do
        expect do
          expect(response[0]).to eq 200
        end.not_to change { WordRepository.new.all.count }

        expect(action.exposures[:word].id).to eq(word.id)
        # Exposes updated word
        expect(action.exposures[:word].question).to eq("A")
        expect(action.exposures[:word_list].id).to eq(word_list.id)

        expect(updated_word.word_list_id).to eq(word_list.id)
        expect(updated_word.question).to eq("A")
        expect(updated_word.answer).to eq("B")
        expect(updated_word.question_example).to eq("C")
        expect(updated_word.answer_example).to eq("D")
      end
    end

    context "when word list belongs to another user" do
      let(:other_user) { create(:user) }
      let(:word_list_user_id) { other_user.id }

      it "renders 403" do
        expect(response[0]).to eq 403
      end
    end

    it "updates the word and word tests" do
      expect do
        expect(response[0]).to eq 200
      end.not_to change { WordRepository.new.all.count }

      expect(action.exposures[:word].id).to eq(word.id)
      expect(action.exposures[:word_list].id).to eq(word_list.id)

      expect(updated_word.word_list_id).to eq(word_list.id)
      expect(updated_word.question).to eq("A")
      expect(updated_word.answer).to eq("B")
      expect(updated_word.question_example).to eq("C")
      expect(updated_word.answer_example).to eq("D")
    end
  end

  context "when user isn't logged in" do
    context "when word list is anonymous" do
      let(:word_list_user_id) { nil }

      it "updates the word and word tests" do
        expect do
          expect(response[0]).to eq 200
        end.not_to change { WordRepository.new.all.count }

        expect(action.exposures[:word].id).to eq(word.id)
        expect(action.exposures[:word_list].id).to eq(word_list.id)

        expect(updated_word.word_list_id).to eq(word_list.id)
        expect(updated_word.question).to eq("A")
        expect(updated_word.answer).to eq("B")
        expect(updated_word.question_example).to eq("C")
        expect(updated_word.answer_example).to eq("D")
      end
    end

    it "renders 403" do
      expect(response[0]).to eq(403)
    end
  end
end
