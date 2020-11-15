RSpec.describe Web::Controllers::Words::Create, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) do
    {
      word: word_params
    }
  end
  let(:word_params) do
    {
      word_list_id: word_list_id,
      question: "Polska",
      answer: "Polonia",
      question_example: "Kocham Polskę",
      answer_example: "Amo Polonia"
    }
  end
  let(:word_list_id) { word_list.id }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:word_list) { create(:word_list, user_id: word_list_user_id) }
  let(:word_list_user_id) { user.id }
  let(:created_word) do
    WordRepository.
      new.
      words.
      order(Sequel.desc(:created_at)).
      map_to(Word).
      one
  end

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    context "when list doesn't exist" do
      let(:word_list_id) { "xd" }

      it "renders 404" do
        expect(response[0]).to eq 404
      end
    end

    context "when word list is anonymous" do
      let(:word_list_user_id) { nil }

      it "creates the Word" do
        expect do
          expect(response[0]).to eq 200
        end.to change { WordRepository.new.all.count }.by(1)

        expect(action.exposures[:word].id).to eq(created_word.id)
        expect(action.exposures[:word_list].id).to eq(word_list.id)

        expect(created_word.word_list_id).to eq(word_list.id)
        expect(created_word.question).to eq("Polska")
        expect(created_word.answer).to eq("Polonia")
        expect(created_word.question_example).to eq("Kocham Polskę")
        expect(created_word.answer_example).to eq("Amo Polonia")
      end
    end

    context "when word list belongs to another user" do
      let(:other_user) { create(:user) }
      let(:word_list_user_id) { other_user.id }

      it "renders 403" do
        expect(response[0]).to eq 403
      end
    end

    context "when invalid values are passed" do
      let(:word_params) do
        super().merge(question: "")
      end

      it "renders 422" do
        expect do
          expect(response[0]).to eq 422
        end.not_to change { WordTestRepository.new.all.count }
      end
    end

    it "creates the Word" do
      expect do
        expect(response[0]).to eq 200
      end.to change { WordRepository.new.all.count }.by(1)

      expect(action.exposures[:word].id).to eq(created_word.id)
      expect(action.exposures[:word_list].id).to eq(word_list.id)

      expect(created_word.word_list_id).to eq(word_list.id)
      expect(created_word.question).to eq("Polska")
      expect(created_word.answer).to eq("Polonia")
      expect(created_word.question_example).to eq("Kocham Polskę")
      expect(created_word.answer_example).to eq("Amo Polonia")
    end
  end

  context "when user isn't logged in" do
    it "renders 403" do
      expect(response[0]).to eq(403)
    end
  end
end
