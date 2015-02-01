# Rails.application.config.assets.precompile += %w( flaticon/flaticon.css )
# Rails.application.config.assets.precompile += %w( flaticon-pack2/flaticon.css )
Rails.application.config.assets.precompile += %w( homepage.css )
Rails.application.config.assets.precompile += %w( homepage.js )

Rails.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
