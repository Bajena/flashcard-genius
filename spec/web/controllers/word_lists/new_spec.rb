RSpec.describe Web::Controllers::WordLists::New, type: :action do
  let(:action) { described_class.new }
  let(:response) { action.call(params) }
  let(:params) { { 'rack.session' => session }.merge(query_params) }
  let(:query_params) { {} }
  let(:session) { {} }
  let(:user) { create(:user) }
  let(:exposed_list) { action.exposures[:word_list] }

  context "when user is logged in" do
    let(:session) { { user_id: user.id } }

    it "exposes correct data" do
      expect(response[0]).to eq 200
      expect(exposed_list.name).to eq("New list")
      expect(exposed_list.words.length).to eq(1)
      expect(exposed_list.words[0].question).to eq(nil)
      expect(exposed_list.words[0].answer).to eq(nil)
    end
  end

  context "when user isn't logged in" do
    it "exposes correct data" do
      expect(response[0]).to eq 200
      expect(exposed_list.name).to eq("New list")
      expect(exposed_list.words.length).to eq(1)
      expect(exposed_list.words[0].question).to eq(nil)
      expect(exposed_list.words[0].answer).to eq(nil)
    end
  end
end
