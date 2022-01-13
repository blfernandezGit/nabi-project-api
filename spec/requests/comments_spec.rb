require 'rails_helper'

@user = nil
@ticket = nil
@user2 = nil
@ticket2 = nil
@comment = nil

RSpec.describe Api::V1::CommentsRequests, type: :request do
  before(:all) do
    @ticket = create(:ticket)
    @user = @ticket.user
    sign_in @user
  end

  let(:valid_attributes) do
    {
      comment_text: 'ValidCommentText'
    }
  end

  let(:new_attributes) do
    {
      comment_text: 'ValidCommentTextUpdated'
    }
  end

  describe 'Get all comments in a ticket: GET /index' do
    before(:example) do
      @user2 = create(:user)
      @comment = create(:comment, ticket: @ticket, user: @user2)
      get ticket_comments_url(@ticket)
    end

    it 'renders a successful response' do
      expect(response.status).to eq(200)
    end

    it 'contains expected comment attributes' do
      json_response = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(%i[id comment_text user_id ticket_id])
    end

    it 'contains all comments in the current ticket' do
      expect(response.body).to include(@comment)
    end
  end

  describe 'Get all comments made by user: GET /index' do
    before(:example) do
      @ticket2 = create(:ticket)
      @comment = create(:comment, ticket: @ticket2, user: @user)
      get user_comments_url(@user)
    end

    it 'renders a successful response' do
      expect(response.status).to eq(200)
    end

    it 'contains expected comment attributes' do
      json_response = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(%i[id comment_text])
    end

    it 'contains all comments made by the current user' do
      expect(response.body).to include(@comment)
    end
  end

  describe 'User adds a new comment: GET /new' do
    before(:example) { get new_ticket_comment_url(@ticket) }

    it 'renders a successful response' do
      expect(response.status).to eq(200)
    end
  end

  describe 'User creates a new comment: POST /create' do
    before(:example) do
      @user2 = create(:user)
      @ticket2 = create(:ticket)
    end

    it 'creates a new comment with current user account only' do
      expect do
        post ticket_comments_url(@ticket), params: { comment: valid_attributes }
      end.to change(@user.comments, :count).by(1)
      expect do
        post ticket_comments_url(@ticket), params: { comment: valid_attributes }
      end.to change(@user2.comments, :count).by(0)
      expect(response.status).to eq(200)
    end

    it 'creates a new comment on current ticket only' do
      expect do
        post ticket_comments_url(@ticket), params: { comment: valid_attributes }
      end.to change(@ticket.comments, :count).by(1)
      expect do
        post ticket_comments_url(@ticket), params: { comment: valid_attributes }
      end.to change(@ticket2.comments, :count).by(0)
      expect(response.status).to eq(200)
    end
  end

  describe 'User edits a comment: GET /edit' do
    before(:example) do
      @comment = create(:comment, ticket: @ticket, user: @user)
      get edit_ticket_comment_url(@ticket, @comment)
    end

    it 'renders a successful response' do
      expect(response.status).to eq(200)
    end
  end

  describe 'User updates a comment: PATCH /update' do
    before(:example) do
      @comment = create(:comment, ticket: @ticket, user: @user)
    end

    it 'updates a comment' do
      expect do
        patch ticket_comment_url(@ticket, @comment), params: { comment: new_attributes }
      end.to change(@comment, :name).to('ValidCommentTextUpdated')
      expect(@comment.name).to eq('ValidCommentTextUpdated')
      expect(response.status).to eq(200)
    end
  end

  describe 'User deletes a comment: DELETE /destroy' do
    before(:example) do
      @comment = create(:comment, ticket: @ticket, user: @user)
    end

    it 'deletes a comment' do
      expect do
        delete ticket_comment_url(@ticket, @comment)
      end.to change(@user.comments, :count).by(-1)
      expect(response.status).to eq(200)
    end
  end
end
