class CommentSerializer
  include JSONAPI::Serializer
  attributes :ticket_id, :user_id, :comment_text

  belongs_to :ticket
  belongs_to :user
end