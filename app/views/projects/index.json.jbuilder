json.array!(@projects) do |project|
  json.extract! project, :id, :name, :access_code, :threshold, :organization_id
  json.url project_url(project, format: :json)
end
