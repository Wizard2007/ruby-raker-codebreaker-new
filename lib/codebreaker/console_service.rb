module Codebreaker
  class ConsoleService
    attr_reader :is_game_over, :is_session_over, :hint_count, :current_game, :user_name, :start_new_game,
                :restaet_was_called,:current_player

    def initializer
      @user_name = ''
      @start_new_game = true
    end

    def start
      @current_game = Game.new
      @current_player = Player.new
      @current_game.start
      @is_session_over = false
      @is_game_over = false
      @hint_count = 1
      @start_new_game = false
      @restaet_was_called = false
    end

    def valid_answer?(user_input)
      (user_input == 'yes') || (user_input == 'no')
    end

    def get_user_input
      user_input = String.new(gets.chomp())
      (user_input != '') ? process_user_input(user_input) : process_user_input(:empty_input)
    end

    def process_user_input(user_input)
      if (!valid_answer?(user_input) && @restaet_was_called)
        send_user_input(:restart_game)
        return
      end
      if @current_game.secret_code_valid?(user_input) then
        send(:show_validation_result, user_input)
      else
        send_user_input(user_input)
      end
    end

    def send_user_input(user_input)
      respond_to?(user_input) ? send(user_input) : send(:unknown_command, user_input.to_s)
    end

    def empty_input
      puts 'your should enter command or digits'
    end

    def your_win
      @is_game_over = true
      puts 'your win'
    end

    def your_loose
      @is_game_over = true
      puts 'your loose'
    end

    def unknown_command(command)
      puts "unknown command '#{command}'"
    end

    def exit_
      @is_session_over = true
      puts 'your exit game'
    end

    def hint
      @hint_count -= 1
      if (@hint_count <0) then
        puts 'your spend all hints'
        @hint_count = 0
      else
        puts "one of digits is : #{@current_game.get_hint_digit}"
      end
    end

    def show_validation_result(code)
      puts "validation result : #{@current_game.check_code(code)}"
    end

    def restart_game
      puts 'start new game? type yes / no'
      @restaet_was_called = true
      get_user_input
    end

    def yes
      @start_new_game = true
      @restaet_was_called = false
      puts 'ok we will start new game'
    end

    def no
      @start_new_game = false
      @restaet_was_called = false
      puts 'ok we will close your session'
    end

    def game_over?
      @is_game_over = false;
      if @current_game.user_win == true
        your_win
        restart_game
        @is_game_over  = true
      end
      if @current_game.game_over?
        your_loose
        restart_game
        result = true
      end
      @is_game_over
    end
    def play_game
      begin
        if !game_over?
          puts 'Enter command or answer'
          get_user_input
        end
      end  until (@is_game_over || @is_session_over)
    end

    def promt_user_name
      puts 'Enter your Name'
      @current_player.name = gets().chomp()
    end

    def app_thread
      begin
        start
        promt_user_name
        play_game
        puts "@start_new_game = #{@start_new_game}"
        puts "@is_session_over = #{@is_session_over}"
      end until (!@start_new_game || @is_session_over)
    end

  end
end
