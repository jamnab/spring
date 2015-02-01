# Rails.application.config.assets.precompile += %w( flaticon/flaticon.css )
# Rails.application.config.assets.precompile += %w( flaticon-pack2/flaticon.css )
Rails.application.config.assets.precompile += %w( homepage.css )
Rails.application.config.assets.precompile += %w( homepage.js )

Rails.application.config.assets.paths << "#{Rails.root}/app/assets/fonts"
