require 'rails_helper'

RSpec.describe EntriesController, type: :controller do

  before(:all) do
    @user = User.create!(name: "Yedhu Krishnan", email: "yedhu@outlook.com")
  end

  describe "POST #create" do
    context "for an authenticated user" do
      describe "when all fields are present" do
        before (:example) do
          @entry_params = [
            {
              uuid: 'abcd2344',
              text: 'Today is a good day',
              address: 'UK 1234',
              date: Time.now,
              latitude: 123.34,
              longitude: 124.23
            },
            {
              uuid: 'abcd2355',
              text: 'Today is a good day',
              address: 'UK 1234',
              date: Time.now - 1.hour,
              latitude: 123.34,
              longitude: 124.23
            }
          ]
        end

        it "creates an entry for the user" do
          request.env['HTTP_AUTHORIZATION'] = "Token token=#{@user.auth_token}"
          post :create, params: { entry: @entry_params }
          expect(response).to have_http_status :created
        end
      end

      describe "when some fields are missing" do
        before (:example) do
          @entry_params = [{
            uuid: 'abcd2344',
          }]
        end

        it "does not create an entry for the user" do
          request.env['HTTP_AUTHORIZATION'] = "Token token=#{@user.auth_token}"
          post :create, params: { entry: @entry_params }
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "for a non-logged in user" do
      it "returns unauthorized status" do
        post :create, params: { entry: {} }
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET #index" do
    before(:example) do
      Entry.create!(uuid: '123', text: 'hello, world', date: Time.now - 3.hours, user: @user)
      Entry.create!(uuid: '456', text: 'avada kedavra', date: Time.now - 2.hours, user: @user)
      Entry.create!(uuid: '789', text: 'valar morghulis' , date: Time.now - 1.hour, user: @user)
    end

    it "gets the entries for current user" do
      request.env['HTTP_AUTHORIZATION'] = "Token token=#{@user.auth_token}"
      get :index
      uuids = JSON.parse(response.body).map { |e| e['uuid'] }
      expect(uuids).to eq(['123', '456', '789'])
    end
  end
end
