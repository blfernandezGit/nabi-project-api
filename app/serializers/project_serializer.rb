class ProjectSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :code, :is_active, :last_ticket_no, :created_at, :updated_at

  has_many :project_memberships
  has_many :users, through: :project_memberships
  has_many :tickets
end
