class Email
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :to, String
  property :subject, String
  property :body, String

  belongs_to :notification
end
