require "rubygems"
require "sanitizr/version"
require "sequel"
require "awesome_print"
require "faker"
require "pry"
require "solid_struct"

module Sanitizr
  class Database
    attr_accessor :db

    def initialize(opts = {})
      opts = { :adapter=>'postgres', :host=>'localhost', :database=>'unsanitized_database' }.merge opts
      self.db = Sequel.connect(opts)
      @fields = []
    end

    def table(table_name, &blk)
      return raise ArgumentException("Please supply a block") unless block_given?
      self.instance_eval(&blk)
      clean(table_name, @fields)
    end

    def field(name, opts = {})
      type = opts.fetch(:type) { name }
      unique = opts.fetch(:unique) { false }

      context = SolidStruct.build(
        type: type,
        name: name,
        unique: unique
      )
      @fields << context
    end

    def clean(table_name, fields)

      dataset = db[table_name].for_update
      count = db[table_name].count
      i = 0
      dataset.each do |row|
        i += 1
        puts "Sanitising #{i} of #{count}"
        updates = fields.map do |field|
          [field.name, send("clean_#{field.type}", field.unique)]
        end

        puts updates.to_h

        dataset.where(id: row[:id]).update(updates.to_h)
      end

      @fields.clear
    end

    private

    def clean_email(unique = false)
      @email_counter ||= 0
      @email_counter += 1

      Faker::Internet.email.gsub("@", "#{@email_counter}@")
    end
    def clean_name(unique = false)
      if unique
        @name_counter ||= 0
        @name_counter += 1
      end
      Faker::Internet.name + (unique ? @name_counter.to_s : "")
    end

    def clean_number(unique = false)
      if unique
        @number_counter ||= 0
        @number_counter += 1
        return (@number_counter.to_s + SecureRandom.random_number(10000000).to_s).to_i
      end
      Faker::Number.number(10)
    end

    def clean_first_name(unique = false)
      if unique
        @first_name_counter ||= 0
        @first_name_counter += 1
      end
      Faker::Name.first_name + (unique ? @first_name_counter.to_s : "")
    end

    def clean_display_name(unique = false)
      if unique
        @display_name_counter ||= 0
        @display_name_counter += 1
      end
      "#{clean_first_name} #{clean_last_name}" + (unique ? @display_name_counter.to_s : "")
    end

    def clean_last_name(unique = false)
      if unique
        @last_name_counter ||= 0
        @last_name_counter += 1
      end
      Faker::Name.last_name + (unique ? @last_name_counter.to_s : "")
    end

    def clean_password(unique = false)
      if unique
        @password_counter ||= 0
        @password_counter += 1
      end
      Faker::Internet.password(10, 20) + (unique ? @password_counter.to_s : "")
    end

    def clean_password_token(unique = false)
      if unique
        @password_token_counter ||= 0
        @password_token_counter += 1
      end
      (0...8).map { (65 + rand(26)).chr }.join + (unique ? @password_token_counter.to_s : "")
    end
  end
end
