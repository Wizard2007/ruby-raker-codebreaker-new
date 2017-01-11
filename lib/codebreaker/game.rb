require 'yaml'
module Codebreaker
  class Game
    attr_accessor :user_name, :hint_count, :code_size, :user_win, :step_count, :max_step_count
    def initialize
      @secret_code = ''
      @code_size = 4
      @step_count = 0
      @max_step_count = 10
      @user_win = false
      @hint_count = 1
    end

    def start
      init_game
    end

    def init_game
      generate_secret_code
      @step_count = 0
      @hint_count = 1
    end
    def save(user_name_)
      player = Player.new
      player.name = user_name_
      player.is_win = user_win
      player.score = step_count
      player.appned('score.yaml')
    end

    def parse_yaml(file)
      YAML::load(File.open(file))
    end

    def open_
      result = '<table>'
      result += '<tr>'
      result += "<td> user name </td>"
      result += "<td> score </td>"
      result += "<td> is_win </td>"
      result += '</tr>'
      items = parse_yaml('score.yaml')
      items.each do |item|
        result += '<tr>'
        result += "<td>#{item.name}</td>"
        result += "<td>#{item.score}</td>"
        result += "<td>#{item.is_win}</td>"
        result += '</tr>'
      end
      result += '</table>'
      result
    end
    def generate_secret_code 
      digits = [1,2,3,4,5,6]
      @secret_code = digits.sample(code_size).join('')
    end

    def game_over?
      @step_count > @max_step_count
    end

    def secret_code_valid?(code = '')
      return false if code.nil?
      l_secret_code = @secret_code
      l_secret_code = code if code != ''
      l_secret_code.match( /[1-6]+/) ? true : false
    end

    def check_user_guess(code)
      @user_win = @secret_code == code
      @user_win ? '++++' : ''
    end

    def check_code(code)
      @step_count += 1
      result = check_user_guess(code)
      return result if @user_win
      l_code = String.new(@secret_code)
      l_copy_code = String.new(code)
      l_copy_code.chars.each_with_index do |element, index|
        l_include_index = -1
        if element == l_code[index]
          result += '+'
          l_code[index] = '*'
          l_copy_code[index] = '*'
        end
      end

      l_copy_code.chars.each_with_index do |element, index|
        if element != '*'
          l_include_index = l_code.index(element)
          if l_include_index then
            result += '-'
            l_code[l_include_index] = '*'
            l_copy_code[l_include_index] = '*'
          end
        end
      end
      result
    end

    def get_hint_digit
      @secret_code.split('').sample
    end
  end
end
