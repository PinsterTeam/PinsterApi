# frozen_string_literal: true

# https://github.com/Apipie/apipie-rails#documentation
Apipie.configure do |config|
  config.app_name = "PinsterApi"
  config.api_base_url = ""
  config.doc_base_url = "/docs"
  config.api_controllers_matcher = Rails.root.join("app", "controllers", "[!concerns/]**", "*.rb")
  config.markup = Apipie::Markup::Markdown.new
  config.translate = false

  config.show_all_examples = 1

  # TODO: Get markdown parser to build this description.
  config.app_info = <<-END_OF_INFO
  Welcome to the PinsterAPI Docs!

  These resources are automatically generated and can sometimes be slightly different than the real thing.
  END_OF_INFO

  config.swagger_content_type_input = :json
  config.swagger_json_input_uses_refs = true
  config.swagger_include_warning_tags = true
  config.swagger_suppress_warnings = false
  config.swagger_api_host = ENV['SWAGGER_HOST']
end
