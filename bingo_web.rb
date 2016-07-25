#!/usr/bin/ruby

require "json"
require "sinatra"
require "./bingo_db.rb"

set :bind, '0.0.0.0'

db = Bingo_DB.new("bingo.db")

db.listTiles

get "/gameboard/:user" do
	string = "<html><head><title>BINGO</title></head><body>"
	if params["id"]
		db.updateTile(params["id"], params["checked"])
		string = "<html><head><meta http-equiv='refresh' content='0; url=/gameboard/#{params[:user]}' /></head></html>"
		erb string
	end
	string = "#{string}<table width='100%' height='100%' border='1' align='center'>"
	gb = db.getGameboard(params[:user])
	["b", "i", "n", "g", "o"].each do |letter|
		string = "#{string}<tr>"
		["1", "2", "3", "4", "5"].each do |number|
			square = "#{letter}#{number}"
			content = gb[square][1]
			id = gb[square][0]
			checked = gb[square][2]
			string = "#{string}<td align='center'><a href='/gameboard/#{params[:user]}?id=#{id}&checked=1'>#{content}</a></td>" if checked == 0
			string = "#{string}<td align='center' bgcolor='#ff9999'><strike><a href='/gameboard/#{params[:user]}?id=#{id}&checked=0'>#{content}</a></strike></td>" if checked == 1
		end
	string = "#{string}</tr>"
	end
	string = "#{string}</table>"
	string = "#{string}<a href='/gameboard/#{params[:user]}'>Refresh</a></body></html>"
	erb string
end

post "/submit_event" do
	p JSON.parse request.body.read
end
