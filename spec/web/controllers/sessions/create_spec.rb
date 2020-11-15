RSpec.describe Web::Controllers::Sessions::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:response) { action.call(params) }

  context "when login succceeds" do
    let(:user) do
      create(:user, :with_password, email: "user@test.com", password: "Test1234")
    end
    let(:params) do
      {
        user: {
          email: user.email,
          password: "Test1234"
        }
      }
    end

    it "sets session.user_id to user's id" do
      response
      expect(action.session[:user_id]).to eq(user.id)
    end

    it "redirects to word lists" do
      expect(response).to redirect_to("/word_lists")
      expect(action.exposures[:flash][:success]).to eq("Logged in succesfully")
    end
  end

  context "when login fails" do
    let(:params) do
      {
        user: {
          email: "xyz@xyz.com",
          password: "zyx"
        }
      }
    end

    it "redirects to login" do
      expect(response).to redirect_to("/login")
      expect(action.exposures[:flash][:error]).to eq("Invalid login information")
      expect(action.session[:user_id]).to eq(nil)
    end
  end
end
