# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rails.logger.debug 'Creating roles...'

Role.create(
  name: 'Admin',
  description: 'The Super Admin role represents the highest level of ' \
               'administrative authority in your Rails API. This role ' \
               'typically has unrestricted access and permissions to ' \
               'manage all aspects of the system.',
  role_type: 1
)

Role.create(
  name: 'Company Admin',
  description: 'The Company Admin role is responsible for handling administrative ' \
               'tasks within your Rails API. Admins typically have elevated ' \
               'privileges and access to specific functionalities for ' \
               'managing users, content, configurations, and other ' \
               'administrative operations from the same company.',
  role_type: 2
)

Role.create(
  name: 'Default User',
  description: 'The Job Seeker role is a type of role that represents individuals ' \
               'who are registered on the application. Users with the ' \
               'role typically have access to features and functionalities ' \
               'related to services offered by the app.',
  role_type: 3
)

Rails.logger.debug 'Creating clients...'
50.times do |index|
  client = Client.create!(
    name: Faker::Company.name,
    description: Faker::Lorem.paragraph,
    client_code: Faker::Alphanumeric.alphanumeric(number: 10)
  )
  client_key_frontend = Faker::Alphanumeric.alphanumeric(number: 100)
  client_secret_frontend = Faker::Alphanumeric.alphanumeric(number: 100)
  Configuration.create(
    client_id: client.id,
    provider: index.zero? ? 'google_oauth2' : OAUTH_PROVIDERS.sample,
    default_scope: 'email username profile',
    client_key_frontend: index.zero? ? ENV.fetch('AUTH0_CLIENT_ID_FRONTEND') : client_key_frontend,
    client_secret_frontend: index.zero? ? ENV.fetch('AUTH0_CLIENT_SECRET_FRONTEND') : client_secret_frontend,
    client_key: index.zero? ? ENV.fetch('AUTH0_CLIENT_ID') : Faker::Alphanumeric.alphanumeric(number: 100),
    client_secret: index.zero? ? ENV.fetch('AUTH0_CLIENT_SECRET') : Faker::Alphanumeric.alphanumeric(number: 100),
    redirect_uri: index.zero? ? ENV.fetch('AUTH0_REDIRECT_URL') : Faker::Internet.url,
    domain: index.zero? ? ENV.fetch('AUTH0_DOMAIN') : Faker::Internet.domain_name,
    audience: index.zero? ? ENV.fetch('AUTH0_AUDIENCE') : Faker::Internet.domain_name,
    custom_fields: [CUSTOM_FIELDS.shuffle.take(rand(1..CUSTOM_FIELDS.length))]
  )
end

Rails.logger.debug 'Creating users...'
100.times do
  User.create(
    client_id: Client.all.sample.id,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    username: "username#{Faker::Number.within(range: 1..999_999)}",
    password: ENV.fetch('DEFAULT_PASSWORD'),
    password_confirmation: ENV.fetch('DEFAULT_PASSWORD'),
    role: Role.all.sample
  )
end

User.first.update(email: 'admin@email.com', role_id: 1)
User.second.update(email: 'client_admin@email.com', role_id: 2)
User.third.update(email: 'default_user@email.com', role_id: 3)
