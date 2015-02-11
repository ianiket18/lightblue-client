require 'lightblue/configuration'

module Lightblue
  extend Configuration

  class Client
    VERSION = '0.0.1.pre'

    attr_accessor *Configuration::VALID_KEYS

    def initialize(options={})

      all_options = Lightblue.options.merge(options)
      Configuration::VALID_KEYS.each { |k| send("#{k}=", all_options[k]) } 

    end

  end
end