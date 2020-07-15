namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Set up the development environment"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Drop the DB...") { %x(rails db:drop) }
      show_spinner("Creating DB...") { %x(rails db:create) }
      show_spinner("Migrating DB...") { %x(rails db:migrate) }
      show_spinner("Registering the default admin DB...") { %x(rails dev:add_default_admin) }
      show_spinner("Registering the default user DB...") { %x(rails dev:add_default_user) }
      
    else
      puts "You aren't on development environment"
    end
  end

  desc "Add default admin"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add default user"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

        def show_spinner(msg_start, msg_end = "Done!")
          spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
          spinner.auto_spin
          yield
          spinner.success("(#{msg_end})")

    end
end