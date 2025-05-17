#creating a class for gaming
class Game

  def initialize(storage)
    @storage = storage.new(ABSOLUTE_PATH_DICTIONARY)
    @word = choose_random_word(@storage.words)
    @guesses = []
    @turn = 0
    @game_name = ""
    @game_loaded = {}
    decide = choose_play_or_load_saved_game
    if decide == "new"
      puts "Lets start a new game"
    elsif decide == "load"
      check_saved_game = @storage.load_json_data
      return puts "Proceed with new game, no game to load !"  if check_saved_game.empty?
      @game_loaded = check_saved_game
      @word = @game_loaded["word"]
      @turn = @game_loaded["turn"]
      @game_name = @game_loaded["name"]
      @guesses = @game_loaded["guesses"]
      puts "The game #{@game_name} has been loaded !"
      print_board(@turn,@word,@guesses)
    end

  end

  def play
    decide = "c"
    loop do
      if decide == "c"
        puts "What letter are you guessing ? "
        guess = player_choose_letter(@guesses)
        @guesses.concat(guess.chars)
        @turn += 1
        if win_or_loose(@guesses,@word) && @turn <= TOTAL_TRIES
          print_board(@turn,@word,@guesses)
          puts "You have guessed the word !"
          return
        elsif  @turn > TOTAL_TRIES
          print_board(@turn,@word,@guesses)
          puts "You have ran out of turn"
          puts "The word is #{@word}"
          return
        end

        print_board(@turn,@word,@guesses)

        puts "Lets try another letter !"
      elsif decide == "s"
        puts "What is this game called ?"
        @game_name = gets.chomp.downcase
        data_to_save = {:name => @game_name, :guesses => @guesses, :word => @word, :turn => @turn }
        @storage.save_json_data (data_to_save)
        return
      end
      decide = choose_save_or_continue_game



    end

  end

  def player_choose_letter(guesses)
    loop do
      guess = gets.chomp.downcase
      previously_guessed = guess.chars.any? {|chr| guesses.include?(chr)}
      number = guess.to_i.to_s == guess
      return guess if guess.length == 1 && !number && !previously_guessed
      puts "Please choose one letter only which is not selected yet"
    end
  end

  def choose_random_word(array)
    array_length = array.length
    random_number = rand(0..array_length)
    return word = array[random_number]
  end

  def print_board(number_of_tries, word, guesses)
    word_length = word.length
    array_of_dashes = Array.new(word_length,"-")
    current_answer = array_of_dashes.map.with_index do |dash,index|
      if guesses.include?(word[index])
        word[index]
      else
        dash
      end
    end
    puts "Number of tries left #{TOTAL_TRIES + 1 - number_of_tries}"
    puts "You have guessed : #{guesses.join(" | ")}"
    puts "Your current guess:  #{current_answer.join(" ")}"
  end

  def win_or_loose(guesses,word)
    if word.chars.all?{|chr| guesses.include?(chr)}
      return true
    else
      return false
    end
  end

  def choose_play_or_load_saved_game
    puts "Do you want to play a game or load a saved game?"
    puts "Type NEW to start a new game or LOAD to load a saved game ! "

    loop do
      decision = gets.chomp.downcase
      return decision if decision == "new" || decision == "load"
      puts "Please select NEW or LOAD"
    end
  end

  def choose_save_or_continue_game
    puts "Do you want to save or continue the game ?"
    puts "Type S to Save or C to CONTINUE"

    loop do
      decision = gets.chomp.downcase
      return decision if decision == "c" || decision == "s"
      puts "Please select S or C"
    end
  end

end