RSpec.describe Web::Controllers::WordTests::Create, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) do
    {
      result: result,
      word_id: word_id
    }
  end
  let(:word_id) { word.id }
  let(:result) { "success" }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:word) { create(:word, user_id: user.id, word_list_id: word_list.id) }
  let(:word_list) { create(:word_list, user_id: word_list_user_id) }
  let(:word_list_user_id) { user.id }
  let(:created_word_test) do
    WordTestRepository.
      new.
      word_tests.
      order(Sequel.desc(:created_at)).
      map_to(WordTest).
      one
  end

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

      it "renders 404" do
        expect(response[0]).to eq 404
      end
    end

    context "when word list belongs to another user" do
      let(:other_user) { create(:user) }
      let(:word_list_user_id) { other_user.id }

      it "renders 404" do
        expect(response[0]).to eq 404
      end
    end

    context "when invalid result is passed" do
      let(:result) { "xd" }

      it "renders 422" do
        expect do
          expect(response[0]).to eq 422
        end.not_to change { WordTestRepository.new.all.count }
      end
    end

    it "creates the WordTest" do
      expect do
        expect(response[0]).to eq 200
        expect(response[2][0]).to eq "ok"
      end.to change { WordTestRepository.new.all.count }.by(1)
      expect(created_word_test.word_id).to eq(word.id)
      expect(created_word_test.result).to eq(result)
    end
  end

  context "when user isn't logged in" do
    it "renders 403" do
      expect(response[0]).to eq(403)
    end
  end
end
