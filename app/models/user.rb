class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # User belongs to and has many projects
  has_many :project_memberships
  has_many :projects, through: :project_memberships
  # User has many authored tickets and has many assigned tickets
  has_many :author_tickets, class_name: "Ticket", foreign_key: "author_id"
  has_many :assignee_tickets, class_name: "Ticket", foreign_key: "assignee_id"
  # User has many comments
  has_many :comments
end
