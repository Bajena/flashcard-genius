RSpec.describe Web::Controllers::Words::Destroy, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) do
    {
      id: word_id
    }
  end
  let(:word_id) { word.id }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:word) { create(:word, user_id: user.id, word_list_id: word_list.id) }
  let!(:word_test) { create(:word_test, word_id: word.id) }
  let(:word_list) { create(:word_list, user_id: word_list_user_id) }
  let(:word_list_user_id) { user.id }

  def reload_word
    WordRepository.new.find(word.id)
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

      it "removes the word and word tests" do
        expect do
          expect do
            expect(response[0]).to eq(200)
            expect(response[2][0]).to eq('ok')
          end.to change { reload_word }.to(nil)
        end.to change { WordTestRepository.new.word_tests.count }.to(0)
      end
    end

    context "when word list belongs to another user" do
      let(:other_user) { create(:user) }
      let(:word_list_user_id) { other_user.id }

      it "renders 403" do
        expect(response[0]).to eq 403
      end
    end

    it "removes the word and word tests" do
      expect do
        expect do
          expect(response[0]).to eq(200)
          expect(response[2][0]).to eq('ok')
        end.to change { reload_word }.to(nil)
      end.to change { WordTestRepository.new.word_tests.count }.to(0)
    end
  end

  context "when user isn't logged in" do
    it "renders 403" do
      expect(response[0]).to eq(403)
    end
  end
end
