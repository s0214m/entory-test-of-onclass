require 'rails_helper'

RSpec.describe Task, type: :model do
  context "titleを指定しているとき" do
    it "taskが作成される" do
      task = build(:task)
      expect(task).to be_valid
    end
  end

  context "titleを指定していないとき" do
    it "taskが作成されない" do
      task = build(:task, title: nil)
      expect(task).to be_invalid
      expect(task.errors.messages[:title][0]).to eq "can't be blank"
    end
  end
end
