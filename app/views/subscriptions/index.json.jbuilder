json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :email, :note
  json.url subscription_url(subscription, format: :json)
end
