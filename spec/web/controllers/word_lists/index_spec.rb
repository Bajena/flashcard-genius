RSpec.describe Web::Controllers::WordLists::Index, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session } }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:flash) { action.exposures[:flash] }

  let!(:word_lists) do
    [
      create(:word_list, :with_words, word_count: 1, user_id: user.id),
      create(:word_list, :with_words, word_count: 2, user_id: user.id),
      create(:word_list, :with_words, word_count: 2, user_id: other_user.id),
      create(:word_list, :with_words, word_count: 2, user_id: nil)
    ]
  end

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }
    let(:exposed_lists) { action.exposures[:word_lists] }

    it "shows user's lists" do
      expect(response[0]).to eq 200
      expect(exposed_lists.length).to eq(2)
    end
  end

  context "when user isn't logged in" do
    it "redirects to login page" do
      expect(response).to redirect_to("/login")
      expect(flash[:error]).not_to be_nil
    end
  end
end
