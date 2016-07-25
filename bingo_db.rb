#!/usr/bin/ruby

require "sqlite3"

class Bingo_DB 
	def initialize(db)
		$db = SQLite3::Database.new "bingo.db"
	end

	def listTiles
		return $db.execute("select id, content, checked from tiles;")
	end

	def createNewGameboard(user)
		tiles = self.listTiles
		gameboard = Hash.new
		["b", "i", "n", "g", "o"].each do |letter|
			[1, 2, 3, 4, 5].each do |number|
				#How many tiles still exist?
				number_of_tiles = tiles.length
				
				#Bingo square. b1, b2, i1...
				square = "#{letter}#{number}"

				#N3 is a free space
				next if square == "n3"

				#Randomly select a tile and get some info
				select_tile = rand(number_of_tiles)
				tile_id = tiles[select_tile][0]

				#Add tile to gameboard hash
				gameboard[square]=tile_id

				#Delete the used tile so all are unique
				tiles.delete(tiles[select_tile])
			end
		end
		gameboard["id"] = rand(999999999)
		$db.execute("INSERT INTO gameboard VALUES(#{gameboard["id"]}, #{gameboard["b1"]}, #{gameboard["b2"]}, #{gameboard["b3"]}, #{gameboard["b4"]}, #{gameboard["b5"]}, #{gameboard["i1"]}, #{gameboard["i2"]}, #{gameboard["i3"]}, #{gameboard["i4"]}, #{gameboard["i5"]}, #{gameboard["n1"]}, #{gameboard["n2"]}, #{gameboard["n4"]}, #{gameboard["n5"]}, #{gameboard["g1"]}, #{gameboard["g2"]}, #{gameboard["g3"]}, #{gameboard["g4"]}, #{gameboard["g5"]}, #{gameboard["o1"]}, #{gameboard["o2"]}, #{gameboard["o3"]}, #{gameboard["o4"]}, #{gameboard["o5"]});")
		$db.execute("UPDATE users SET gameboard=#{gameboard["id"]} where name='#{user}';")
	end

	def getTile(tile_id)
		return $db.execute("SELECT id, content, checked FROM tiles WHERE id=#{tile_id}").first
	end

	def updateTile(tile_id, checked)
		$db.execute("UPDATE tiles SET checked=#{checked} WHERE id=#{tile_id};")
	end

	def getGameboard(user)
		gameboard = Hash.new
		gameboard_id = $db.execute("SELECT gameboard FROM users WHERE name='#{user}';").first.first
		gameboard_data = $db.execute("SELECT * FROM gameboard WHERE id=#{gameboard_id};").first
		gameboard["b1"] = self.getTile gameboard_data[1]
		gameboard["b2"] = self.getTile gameboard_data[2]
		gameboard["b3"] = self.getTile gameboard_data[3]
		gameboard["b4"] = self.getTile gameboard_data[4]
		gameboard["b5"] = self.getTile gameboard_data[5]
		gameboard["i1"] = self.getTile gameboard_data[6]
		gameboard["i2"] = self.getTile gameboard_data[7]
		gameboard["i3"] = self.getTile gameboard_data[8]
		gameboard["i4"] = self.getTile gameboard_data[9]
		gameboard["i5"] = self.getTile gameboard_data[10]
		gameboard["n1"] = self.getTile gameboard_data[11]
		gameboard["n2"] = self.getTile gameboard_data[12]
		gameboard["n3"] = [1, "FREE", 1]
		gameboard["n4"] = self.getTile gameboard_data[13]
		gameboard["n5"] = self.getTile gameboard_data[14]
		gameboard["g1"] = self.getTile gameboard_data[15]
		gameboard["g2"] = self.getTile gameboard_data[16]
		gameboard["g3"] = self.getTile gameboard_data[17]
		gameboard["g4"] = self.getTile gameboard_data[18]
		gameboard["g5"] = self.getTile gameboard_data[19]
		gameboard["o1"] = self.getTile gameboard_data[20]
		gameboard["o2"] = self.getTile gameboard_data[21]
		gameboard["o3"] = self.getTile gameboard_data[22]
		gameboard["o4"] = self.getTile gameboard_data[23]
		gameboard["o5"] = self.getTile gameboard_data[24]
		return gameboard
	end

end
