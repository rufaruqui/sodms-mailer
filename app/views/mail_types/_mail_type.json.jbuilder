json.extract! mail_type, :id, :name, :description, :schedule, :created_at, :updated_at
json.url mail_type_url(mail_type, format: :json)
