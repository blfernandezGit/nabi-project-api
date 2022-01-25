class TicketSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :resolution, :status, :ticket_no,
             :created_at, :updated_at
  attributes :project do |object|
    {
      code: object.project.code,
      name: object.project.name
    }
  end
  attributes :author do |object|
    {
      username: object.author.username
    }
  end
  attributes :assignee do |object|
    if object.assignee
      {
        username: object.assignee.username
      }
    else
      {}
    end
  end
  attributes :related_tickets do |object|
    object.related_tickets.collect do |related_ticket|
      {
        ticket_no: related_ticket.ticket_no,
        title: related_ticket.title,
        status: related_ticket.status
      }
    end
  end
  attributes :inverse_related_tickets do |object|
    object.inverse_related_tickets.collect do |related_ticket|
      {
        ticket_no: related_ticket.ticket_no,
        title: related_ticket.title,
        status: related_ticket.status
      }
    end
  end
  attributes :comments do |object|
    object.comments.collect do |comment|
      {
        comment_text: comment.comment_text,
        author: comment.user.username,
        created_at: comment.created_at,
        updated_at: comment.updated_at
      }
    end
  end
end
