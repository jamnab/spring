Paperclip::Attachment.default_options[:path] = ":class/:attachment/:id/:style/:filename"
Paperclip::Attachment.default_options[:use_timestamp] = false
Paperclip::Attachment.default_options[:azure_credentials] = {
    storage_account_name: 'launchboardcdn',
    access_key:           'QJvSH/6eEEUXQ8vpdz4BkOdaqPlBOfEboSuHeQdq3jLeIXviBX6BLmDiwZRK0Re/5JGzp6kv0Hf/1yKztT3Gug==',
    container:            'paperclip'
}
