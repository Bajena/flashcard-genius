# frozen_string_literal: true

RSpec.describe LoginUser do
  let(:interactor) { described_class.new }
  let(:attributes) { Hash[email: email, password: password] }
  let(:result) { interactor.call(attributes) }
  let!(:user) do
    create(:user, :with_password, email: user_email, password: user_password)
  end
  let(:user_email) { "user@email.com" }
  let(:user_password) { "Test1234" }
  let(:email) { user_email }
  let(:password) { user_password }

  context "when a user with given email exists" do
    context "when password is correct" do
      it "succeeds" do
        expect(result.successful?).to be(true)
        expect(result.user.email).to eq(email)
      end
    end

    context "when password is incorrect" do
      let(:password) { "bad" }

      it "fails" do
        expect(result.successful?).to be(false)
        expect(result.error).to eq("Invalid login information")
        expect(result.user).to eq(nil)
      end
    end
  end

  context "when a user with given email doesn't exist" do
    let(:email) { "dada@dada.com" }

    it "fails" do
      expect(result.successful?).to be(false)
      expect(result.error).to eq("Invalid login information")
      expect(result.user).to eq(nil)
    end
  end
end
