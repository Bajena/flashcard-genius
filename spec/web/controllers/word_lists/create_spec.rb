RSpec.describe Web::Controllers::WordLists::Create, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { { word_list: word_list_params } }
  let(:word_list_params) do
    {
      name: name
    }
  end
  let(:name) { "My list" }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:exposed_list) { action.exposures[:word_list] }
  let(:created_list) do
    WordListRepository.
      new.
      word_lists.
      order(Sequel.desc(:created_at)).
      map_to(WordList).
      one
  end

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    it "creates the list" do
      expect do
        expect(response[0]).to eq 302
      end.to change { WordListRepository.new.all.count }.by(1)
      expect(created_list.user_id).to eq(user.id)
      expect(created_list.name).to eq(name)
    end

    context "when list is invalid" do
      let(:name) { "" }

      it "exposes the list and renders errors" do
        expect do
          expect(response[0]).to eq 422
        end.not_to change { WordListRepository.new.all.count }

        expect(exposed_list.name).to eq(name)
        expect(action.params.error_messages).to eq(["Name must be filled"])
      end
    end
  end

  context "when user isn't logged in" do
    it "creates an anonymous list" do
      expect do
        expect(response[0]).to eq 302
      end.to change { WordListRepository.new.all.count }.by(1)
      expect(created_list.user_id).to eq(nil)
      expect(created_list.name).to eq(name)
    end
  end
end
