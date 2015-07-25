fs = require 'fs'
toTypeForm = require './to-typeform'

if not process.argv[2]
	console.log 'Specify input filename'
	return -1

bookToJson = (filename) ->
	contents = fs.readFileSync filename
	contents = contents.toString()
	qas = toTypeForm contents
	return JSON.stringify(qas, undefined, 2)

console.log bookToJson process.argv[2]