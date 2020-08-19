namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Set up the development environment"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Drop the DB...") { %x(rails db:drop) }
      show_spinner("Creating DB...") { %x(rails db:create) }
      show_spinner("Migrating DB...") { %x(rails db:migrate) }
      show_spinner("Registering the default admin DB...") { %x(rails dev:add_default_admin) }
      show_spinner("Registering more admins DB...") { %x(rails dev:add_more_admins) }
      show_spinner("Registering the default user DB...") { %x(rails dev:add_default_user) }
      show_spinner("Registering the standard subjects ...") { %x(rails dev:add_subjects) }

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

  desc "Add more admins"
  task add_more_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Add default user"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add the standard subjects"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end
  

  private

        def show_spinner(msg_start, msg_end = "Done!")
          spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
          spinner.auto_spin
          yield
          spinner.success("(#{msg_end})")

    end
end