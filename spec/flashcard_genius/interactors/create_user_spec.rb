# frozen_string_literal: true

RSpec.describe CreateUser do
  let(:interactor) { described_class.new }
  let(:email) { "user@email.com" }
  let(:password) { "Test1234" }
  let(:attributes) { Hash[email: email, password: password] }
  let(:result) { interactor.call(attributes) }

  context "good input" do
    it "succeeds" do
      expect(result.successful?).to be(true)
    end

    it "creates a User with email and password" do
      expect(result.user.email).to eq("user@email.com")
      expect(result.user.password_digest).to be_a(String)
    end

    context "when email is already taken" do
      let!(:user) { create(:user, email: email) }

      it "fails" do
        expect(result.successful?).to eq(false)
        expect(result.errors).to eq(['Email is already taken'])
      end
    end
  end

  context "when email is blank" do
    let(:email) { "" }

    it "returns an error" do
      expect(result.successful?).to eq(false)
      expect(result.errors).to eq(['Email must be filled'])
    end
  end

  context "when email is not valid" do
    let(:email) { "asdf@da" }

    it "returns an error" do
      expect(result.successful?).to eq(false)
      expect(result.errors).to eq(['Email is in invalid format'])
    end
  end

  context "when password is blank" do
    let(:password) { "" }

    it "returns an error" do
      expect(result.successful?).to eq(false)
      expect(result.errors).to eq(['Password must be filled'])
    end
  end
end
