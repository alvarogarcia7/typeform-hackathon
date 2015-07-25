request = require 'request'
fs = require 'fs'
toTypeForm = require './to-typeform'

if process.env.TYPEFORM_API_KEY is undefined
	console.log "Your TYPEFORM_API_KEY is not defined. Please export it"
	return -1

api_key = process.env.TYPEFORM_API_KEY

console.log "Using your API key", api_key

if not process.argv[2]
	console.log 'Specify input filename'
	return -1

bookToJson = (filename) ->
	contents = fs.readFileSync filename
	contents = contents.toString()
	typeForm = toTypeForm contents
	#return JSON.stringify(qas, undefined, 2)
	return typeForm

json = bookToJson process.argv[2]

console.log "Posting JSON: ", json

request.post 'https://api.typeform.io/v0.3/forms', {
	json: json
	headers: 
		'X-API-TOKEN': api_key
}, (error, response, body) ->
	console.log 'Request complete: ', error
	console.log 'Response: ', body