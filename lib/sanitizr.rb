require "rubygems"
require "sanitizr/version"
require "sequel"
require "awesome_print"
require "faker"
require "pry"
require 'ostruct'

module Sanitizr
  class Database
    attr_accessor :db

    def initialize(opts = {})
      opts = { :adapter=>'postgres', :host=>'localhost', :database=>'food-portal_development' }.merge opts
      self.db = Sequel.connect(opts)
      @fields = []
    end

    def table(table_name,&blk)
      return raise ArgumentException("Please supply a block") unless block_given?
      self.instance_eval(&blk)
      clean(table_name,@fields)
    end

    def field(name, opts = {})
      type = opts.fetch(:type) { name }
      unique = opts.fetch(:unique) { false }

      context = OpenStruct.new
      context.type = type
      context.name = name
      context.unique = unique
      @fields << context
    end

    def clean(table_name, fields)

      dataset = db[table_name].for_update

      dataset.each do |row|
        fields.each do |field|
          value = ""

          loop do
            value =  send("clean_#{field.type}")
            break if field.unique == false ||  unique?(field.name,dataset,value)
          end

          dataset.where(id: row[:id]).update( field.name => value)
        end
      end

      @fields.clear

    end

    private

    def clean_email
      @email_counter ||= 0
      @email_counter += 1
      Faker::Internet.email.gsub("@", "#{@email_counter}@")
    end
    def clean_name
      Faker::Internet.name
    end

    def clean_number
      Faker::Number.number(10)
    end

    def clean_first_name
      Faker::Name.first_name
    end
    def clean_display_name
      "#{clean_first_name}.#{clean_last_name}"
    end

    def clean_last_name
      Faker::Name.last_name
    end

    def clean_password
      Faker::Internet.password(10, 20)
    end

    def clean_password_token
  	   (0...8).map { (65 + rand(26)).chr }.join
    end

    def unique?(field_name,dataset,value)
      dataset.where(field_name => value).empty?
    end

  end
end
