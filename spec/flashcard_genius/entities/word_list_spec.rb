RSpec.describe WordList, type: :entity do
  describe "anonymous?" do
    let(:result) { build(:word_list, user_id: user_id).anonymous? }

    context "when user_id is nil" do
      let(:user_id) { nil }

      it "returns true" do
        expect(result).to eq(true)
      end
    end

    context "when user_id is not nil" do
      let(:user_id) { 1 }

      it "returns false" do
        expect(result).to eq(false)
      end
    end
  end

  describe "editable_by?" do
    let(:result) do
      build(:word_list, user_id: user_id).editable_by?(current_user)
    end
    let(:current_user) { build(:user, id: 1) }

    context "when list is anonymous" do
      let(:user_id) { nil }

      it "returns true" do
        expect(result).to eq(true)
      end
    end

    context "when list doesn't belong to current user" do
      let(:user_id) { 2 }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when list has id and current user is nil" do
      let(:user_id) { 2 }
      let(:current_user) { nil }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when list belongs to current user" do
      let(:user_id) { current_user.id }

      it "returns true" do
        expect(result).to eq(true)
      end
    end
  end

  describe "learnable_by?" do
    let(:result) do
      build(:word_list, user_id: user_id).learnable_by?(current_user)
    end
    let(:current_user) { build(:user, id: 1) }

    context "when list is anonymous" do
      let(:user_id) { nil }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when current user is nil" do
      let(:current_user) { nil }
      let(:user_id) { 1 }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when list doesn't belong to current user" do
      let(:user_id) { 2 }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when list belongs to current user" do
      let(:user_id) { current_user.id }

      it "returns true" do
        expect(result).to eq(true)
      end
    end
  end
end
