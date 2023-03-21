require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    subject { get(tasks_path) }
    before { create_list(:task, 3)}
    it "タスクのレコード一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to include("title", "description", "due_date", "completed")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /tasks/:id" do
    subject { get(task_path(task_id)) }
    context "指定したidのタスクが存在するとき" do
      let(:task) { create(:task) }
      let(:task_id) { task.id }
      it "任意のタスクレコードを取得できる" do
        subject
        res = JSON.parse(response.body)
        due_date = Date.parse(res["due_date"])
        expect(res.length).to eq 7
        expect(res["title"]).to eq task.title
        expect(res["description"]).to eq task.description
        expect(due_date).to eq task.due_date
        expect(res["completed"]).to eq task.completed
        expect(response).to have_http_status(200)
      end
    end

    context "指定したidのタスクが存在しないとき" do
      let(:task_id) { 100000 }
      it "タスクレコードを取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /tasks" do
    subject { post(tasks_path, params: params) }
    context "適切なパラメーターを送信したとき" do
      let(:params) { { task: attributes_for(:task) } }
      it "任意のタスクレコードを作成できる" do
        expect { subject }.to change { Task.count }.by(1)
        res = JSON.parse(response.body)
        due_date = Date.parse(res["due_date"])
        expect(res["title"]).to eq params[:task][:title]
        expect(res["description"]).to eq params[:task][:description]
        expect(due_date).to eq params[:task][:due_date]
        expect(res["completed"]).to eq params[:task][:completed]
        expect(response).to have_http_status(201)
      end
    end

    context "不適切なパラメーターを送信したとき" do
      let(:params) { attributes_for(:task) }
      it "エラーする" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH /tasks/:id" do
    subject { patch(task_path(task_id), params: params) }
    let(:params) {
      {
        task: {
          title: Faker::Lorem.sentence(word_count: 3),
          created_at: 1.day.ago
        }
      }
    }
    let(:task_id) { task.id }
    let(:task) { create(:task) }
    it "任意のタスクレコードを更新できる" do
      expect { subject }.to change { task.reload.title }.from(task.title).to(params[:task][:title])&
        not_change { task.reload.description }&
        not_change { task.reload.due_date }&
        not_change { task.reload.completed }&
        not_change { task.reload.created_at }
    end
  end

  describe "DELETE /tesks/:id" do
    subject { delete(task_path(task_id)) }
    let(:task_id) { task.id }
    let!(:task) { create(:task)}
    it "任意のタスクレコードを削除できる" do
      expect { subject }.to change { Task.count }.by(-1)
    end
  end
end
