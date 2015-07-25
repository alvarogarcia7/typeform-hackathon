#Parse a Book DSL and return a TypeForm JSON

_ = require 'underscore'


trimstr = (s) -> s.replace(/^\s+/, '').replace(/\s+$/, '')

prepareStr = (s) ->
	s = trimstr s
	s = s.replace /`/g, "```"

toTypeForm = (contents) ->
	qas = contents.split '\n---\n'

	qas = qas.map (item) -> 
		split = item.split '\n?\n'
		result = 
			q: trimstr split[0]
			a: trimstr split[1]

	#Generate the typeform component
	#

	nonEmpty = (item) -> if item?.length > 0 then true else false


	makeDesc = (lines) ->
		result = 
			question: prepareStr lines.shift()
			description: prepareStr lines.join('\n')

	parseQuestion = (q) ->
		q = q.filter nonEmpty

		type = q[0]

		if (type is "@short_text")
			type = type.substr 1
			q.shift()
		else
			type = "yes_no"

		quest = _.extend {type: type}, makeDesc q

	toComponent = (qa) ->
		q = qa.q.split '\n'
		a = qa.a.split '\n'

		question = parseQuestion q
		answer = _.extend {type: "statement"}, makeDesc a

		return [question, answer]


	#generate it!
	fields = _.flatten (qas.map toComponent)
	result = 
		title: "The little Schemer book"
		fields: fields

module.exports = toTypeForm