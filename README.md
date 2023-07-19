# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  ```ruby
  This application uses Ruby version 3.2.2. You can install it using a version manager like rbenv or rvm.
* System dependencies
  ```ruby
  This application uses PostgreSQL as the database. You will need to have PostgreSQL installed and running on your local machine.
* Configuration
    1. Clone the repository to your local machine.
       ```ruby
       git clone https://github.com/alexjabf/sso-api.git
    2. Run bundle install to install the required gems inside the main-api project.
       ```ruby
       bundle install
* Database creation and initialization
   ```ruby
   rails db:create:migrate:seed
* How to run the test suite
   ```ruby
   bundle exec rspec
* Services (job queues, cache servers, search engines, etc.)
  ```ruby
  For the moment this application does not use any external services such as job queues, cache servers, or search engines.
* Deployment instructions.
    1. Create a new Heroku app.
       ```ruby
       heroku create
    2. Provision a PostgreSQL database for the app.
       ```ruby
       heroku addons:create heroku-postgresql
    3. Push the code to Heroku.
       ```ruby
       git push heroku main
    4. Run the database migrations on Heroku.
       ```ruby
       heroku run rails db:migrate
    5. Seed the database with any necessary data.
       ```ruby
       heroku run rails db:seed
    6. Open the app in your browser.
       ```ruby
       heroku open