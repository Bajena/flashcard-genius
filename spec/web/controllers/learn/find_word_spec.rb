RSpec.describe Web::Controllers::Learn::FindWord, type: :action do
  let(:action) { described_class.new }
  let(:params) do
    {
      'rack.session' => session,
      'router.params' => router_params
    }
  end
  let(:router_params) { { word_list_id: word_list_id } }
  let(:response) { action.call(params) }
  let(:user) { create(:user) }
  let(:session) { { user_id: user.id } }
  let(:word_list) do
    create(:word_list, user_id: user.id)
  end
  let!(:word) { create(:word, word_list_id: word_list.id) }
  let(:word_list_id) { word_list.id }

  context "when user is not logged in" do
    let(:session) { {} }

    it 'redirects to login' do
      expect(response).to redirect_to("/login")
    end
  end

  context "when word list belongs to another user" do
    let(:word_list) do
      create(:word_list, :with_words, user_id: create(:user).id)
    end

    it "does not return a word" do
      expect(response[0]).to eq 200

      expect(action.exposures[:word_list]).to eq(nil)
      expect(action.exposures[:word]).to eq(nil)
      expect(action.exposures[:last_test_at]).to eq(nil)
    end
  end

  context "when word list is anonymous" do
    let(:word_list) do
      create(:word_list, :with_words, :anonymous)
    end

    it "does not return a word" do
      expect(response[0]).to eq 200

      expect(action.exposures[:word_list]).to eq(nil)
      expect(action.exposures[:word]).to eq(nil)
      expect(action.exposures[:last_test_at]).to eq(nil)
    end
  end

  context "when word was already tested recently" do
    before do
      create(:word_test, word_id: word.id, result: "success")
    end

    it "does not return the word" do
      expect(response[0]).to eq 200

      expect(action.exposures[:word_list]).to eq(nil)
      expect(action.exposures[:word]).to eq(nil)
      expect(action.exposures[:last_test_at]).to eq(nil)
    end
  end

  context "when word was already tested long time ago" do
    let(:word_test_1) do
      create(
        :word_test,
        word_id: word.id,
        result: "success",
        created_at: DateTime.now - 30
      )
    end
    let(:word_test_2) do
      create(
        :word_test,
        word_id: word.id,
        result: "failed",
        created_at: DateTime.now - 14
      )
    end

    before do
      word_test_1
      word_test_2
    end

    it "returns the word" do
      expect(response[0]).to eq 200

      expect(action.exposures[:word_list].id).to eq(word_list.id)
      expect(action.exposures[:word].id).to eq(word.id)
      expect(action.exposures[:last_test_at]).to eq(word_test_2.created_at)
    end
  end

  context "when word list param is not provided" do
    let(:router_params) { {} }

    it "returns the word" do
      expect(response[0]).to eq 200

      expect(action.exposures[:word_list].id).to eq(word_list.id)
      expect(action.exposures[:word].id).to eq(word.id)
      expect(action.exposures[:last_test_at]).to eq(nil)
    end

    context "when word list belongs to another user" do
      let(:word_list) do
        create(:word_list, :with_words, user_id: create(:user).id)
      end

      it "does not return a word" do
        expect(response[0]).to eq 200

        expect(action.exposures[:word_list]).to eq(nil)
        expect(action.exposures[:word]).to eq(nil)
        expect(action.exposures[:last_test_at]).to eq(nil)
      end
    end
  end

  it "returns a word" do
    expect(response[0]).to eq 200

    expect(action.exposures[:word_list].id).to eq(word_list.id)
    expect(action.exposures[:word].id).to eq(word.id)
    expect(action.exposures[:last_test_at]).to eq(nil)
  end
end
