require 'codebreaker/version'

require 'codebreaker/game'
require 'codebreaker/console_service'
require 'yaml'
module Codebreaker

  module YamlIO

    def appned(file_name)
      array_player = []
      array_player = YAML::load(File.open(file_name))
      array_player << self
      yaml_string = array_player.to_yaml
      File.write(file_name, yaml_string)
    end

  end

  class Player

    include(YamlIO)

    attr_accessor :name, :score, :is_win
    def to_s
      "#{name}, #{score}, #{is_win}"
    end
    def initialize
      @name = ''
      @score = 0
      @is_win = false
    end

  end
end
