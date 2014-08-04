json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :endorsed, :anonymous, :commentable_id, :commentable_type
  json.url comment_url(comment, format: :json)
end
