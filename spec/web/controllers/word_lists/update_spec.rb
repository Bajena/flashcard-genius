RSpec.describe Web::Controllers::WordLists::Update, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) do
    {
      'rack.session' => session,
      'router.params' => router_params
    }
  end
  let(:router_params) do
    {
      id: word_list_id,
      word_list: word_list_params
    }
  end
  let(:word_list_params) do
    {
      name: name
    }
  end
  let(:name) { "My list" }
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

      it "updates the list" do
        expect(response[0]).to eq 302
        expect(updated_list.user_id).to eq(nil)
        expect(updated_list.name).to eq(name)
        expect(updated_list.words.length).to eq(1)
      end

      context "when params include user_id" do
        it "doesn't update the user_id" do
          expect(response[0]).to eq 302
          expect(updated_list.user_id).to eq(nil)
        end
      end

      context "when list is invalid" do
        let(:name) { "" }

        it "exposes the list and renders errors" do
          expect do
            expect(response[0]).to eq 422
          end.not_to change { reload_list.updated_at }

          expect(exposed_list.name).to eq(name)
          expect(action.params.error_messages).to eq(["Name must be filled"])
        end
      end
    end

    context "when list belongs to the user" do
      it "updates the list" do
        expect(response[0]).to eq 302
        expect(updated_list.user_id).to eq(user.id)
        expect(updated_list.name).to eq(name)
        expect(updated_list.words.length).to eq(1)
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

      it "updates the list" do
        expect(response[0]).to eq 302
        expect(updated_list.user_id).to eq(nil)
        expect(updated_list.name).to eq(name)
        expect(updated_list.words.length).to eq(1)
      end
    end
  end
end
