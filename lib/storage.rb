class Storage
  attr_reader :words
  def initialize(file_name)
    @dictionary = File.read(file_name).split("\n")
    @words = filter_words(@dictionary)
  end

  def filter_words(words)
    words.filter do |word|
      word.length >= 5 && word.length <= 12
    end
  end

  def save_json_data(current_data)
    file = File.read(ABSOLUTE_PATH_SAVED_DATA)
    begin
      data_to_hash = JSON.parse(file)
    rescue => e
      data_to_hash = []
    end
    join_current_data = data_to_hash.push(current_data)
    File.write(ABSOLUTE_PATH_SAVED_DATA, JSON.dump(join_current_data))
    puts "The game is saved !!"
  end

  def load_json_data
    file = File.read(ABSOLUTE_PATH_SAVED_DATA)
    begin
      data_to_hash = JSON.parse(file)
    rescue => e
      puts "The file is empty !"
      return
    end
    return data_to_hash if data_to_hash.empty?
    puts "Which game do you want to load ? "

    data_to_hash.each {|hash| puts "Game names that exist : #{hash["name"]}" }
    game_selected = ""
    loop do
      game_selected = gets.chomp.downcase
      index_of_selected_game = data_to_hash.index {|hash| hash["name"] == game_selected}
      selected_game = ''
      hash_name_exist = data_to_hash.any? {|hash| hash["name"] == game_selected}
      if hash_name_exist
        selected_game = data_to_hash[index_of_selected_game]
        data_to_hash.delete_at(index_of_selected_game)
        File.write(ABSOLUTE_PATH_SAVED_DATA, JSON.dump(data_to_hash))
        return selected_game
      end
      puts "Please choose the available game names !"
    end

  end



end