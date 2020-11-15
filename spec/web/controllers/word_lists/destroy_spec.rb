RSpec.describe Web::Controllers::WordLists::Destroy, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { { id: word_list_id } }
  let(:word_list_id) { word_list.id }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:word_list) { create(:word_list, :with_words, user_id: word_list_user_id) }
  let(:word_list_user_id) { user.id }
  let!(:other_user_word_list) { create(:word_list, user_id: other_user.id) }

  def reload_list
    WordListRepository.new.find(word_list.id)
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

      it "renders 403" do
        expect(response[0]).to eq 403
      end
    end

    context "when list is anonymous" do
      let(:word_list_user_id) { nil }

      it "destroys the list and words" do
        expect do
          expect do
            expect(response).to redirect_to("/")
          end.to change { reload_list }.to(nil)
        end.to change { WordRepository.new.words.where(word_list_id: word_list_id).count }.to(0)
      end
    end

    context "when list belongs to the user" do
      it "destroys the list and words" do
        expect do
          expect do
            expect(response).to redirect_to("/")
          end.to change { reload_list }.to(nil)
        end.to change { WordRepository.new.words.where(word_list_id: word_list_id).count }.to(0)
      end
    end
  end

  context "when user isn't logged in" do
    context "when list belongs to a user" do
      it "renders 403" do
        expect(response[0]).to eq 403
      end
    end

    context "when list is anonymous" do
      let(:word_list_user_id) { nil }

      it "destroys the list and words" do
        expect do
          expect do
            expect(response).to redirect_to("/")
          end.to change { reload_list }.to(nil)
        end.to change { WordRepository.new.words.where(word_list_id: word_list_id).count }.to(0)
      end
    end
  end
end
