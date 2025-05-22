require_relative "lib/game"
require_relative "lib/storage"
require "json"

TOTAL_TRIES = 20
ABSOLUTE_PATH_DICTIONARY = "/Users/vikneswaransathasivam/Documents/repos/hangman/lib/dictionary.txt"
ABSOLUTE_PATH_SAVED_DATA = "/Users/vikneswaransathasivam/Documents/repos/hangman/lib/saved_data.json"

Game.new(Storage).play
