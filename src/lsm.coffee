pos = require 'pos'
lexer = new pos.Lexer()
tagger = new pos.Tagger()
fwords = require './fwords'

# Absolute Difference Score
abs_diff_score = (preps1, preps2) ->
	difference = (Math.abs(preps1 - preps2) / (preps1 + preps2))
	if difference is Infinity
		return 0
	else
		return 1 - difference

# returns an array of all the tags found in the text body
lex_and_tag = (text) ->
	words = lexer.lex(text)
	tags = tagger.tag(words)
	(tag[1] for tag in tags)

Counter = (arr) ->
	# like Python's Counter(), returns an object whose keys 
	# are the elements in `arr`, and whose values are the number
	# of times its key appeared in `arr`.
	counter = {}
	for item in arr
		if counter[item]
			counter[item] += 1
		else 
			counter[item] = 1
	return counter

# calculate the percentage of each function group
# as a proportion of the total text body
calc_percents = (counter) ->
	funcs = {}
	if not (k for k,v of counter).length then return funcs
	total = (v for k,v of counter).reduce (x,y) -> x + y
	for func in fwords
		funcs[func] = counter[func] / total
	return funcs

class LSM
	constructor: (opts) ->
		if typeof(opts) is typeof('')
			@text = opts
		else
			@text = opts.text
			@percents = opts.percents

		# if percents is falsy, derive profile from text
		if not @percents
			@tags = lex_and_tag @text
			@counter = Counter @tags
			@percents = calc_percents @counter

	compare: (other) ->
		total = []
		for func, percent of @percents
			weight = Math.abs(1 - (percent + other.percents[func])/2)
			diff = abs_diff_score percent, other.percents[func]
			total.push diff * weight
		if total.length
			sum = total.reduce (prev, curr) ->
				if prev then prev + curr else curr
			return sum / total.length
		else
			return 0

	combine: (other) ->
		# returns a new LSM by combining two text bodies
		return new LSM
			text: other.text or other
			percents: other.percents

exports.LSM = LSM