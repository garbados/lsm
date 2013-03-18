fwords = require './fwords'

abs_diff_score = (preps1, preps2) ->
	# .0001 to stay consistent with academic research's formula
	return 1 - (Math.abs(preps1 - preps2) / (preps1 + preps2 + .0001))

reduce_to_words = (text) ->
	(word.toLowerCase() for word in text.match(/\w+/g))

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

class LSM
	constructor: (@text) ->
		if @text
			@reduced = reduce_to_words @text
			@counter = Counter(@reduced)
			@fwords = {}
			@percents = {}
			@calc_percents()

	calc_percents: () ->
		# flesh out @fwords and @percents
		for func, wordlist of fwords
			@fwords[func] = 0
			for word in wordlist
				@fwords[func] += @counter[word] or 0
			@percents[func] = @fwords[func] / @reduced.length

	compare: (other) ->
		total = []
		for func, percent of @percents
			weight = Math.abs(1 - (percent + other.percents[func])/2)
			diff = abs_diff_score percent, other.percents[func]
			total.push diff * weight
		sum = total.reduce (prev, curr) ->
			if prev then prev + curr else curr
		return sum / total.length

	combine: (other) ->
		# returns a new LSM by combining two text bodies
		text = other.text or other
		return new LSM(@text + ' ' + text)

exports.LSM = LSM