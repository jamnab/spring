json.array!(@posts) do |post|
  json.extract! post, :id, :title, :content, :endorsed, :anonymous, :threshold, :user_id, :project_id
  json.url post_url(post, format: :json)
end
