lsm = require('./lsm').LSM
fs = require 'fs'
cmb = require('js-combinatorics').Combinatorics
assert = require 'assert'

# is x.compare(x) == 1?
is_autosimilar = (texts) ->
	for text in (text.text for text in texts)
		autolikeness = text.compare text
		if autolikeness != 1
			return false
	return true

# compute most like each other
most_alike = (texts) ->
	combos = cmb.combination texts, 2
	results = []
	while next = combos.next()
		likeness = next[0].text.compare(next[1].text)
		results.push [next[0].name, next[1].name, likeness]
	results.sort (a,b) ->
		return b[2] - a[2]

# compute most like the average
most_average = (texts) ->
	profiles = {}
	everybody = new lsm('')
	for text in texts
		profiles[text.name] = text.text
		everybody = everybody.combine text.text
	results = []
	for name, profile of profiles
		results.push
			name: name,
			value: profile.compare(everybody)
	results.sort (a, b) ->
		return b.value - a.value
	return results

# get files and execute
texts = []
fs.readdir "#{__dirname}/../data", (err, files) ->
	for file in files
		do (file) ->
			fs.readFile "#{__dirname}/../data/#{file}", (err, data) ->
				texts.push
					name: file, 
					text: new lsm data.toString()
				# run tests once all texts have been read
				if files.length is Object.keys(texts).length
					assert is_autosimilar texts
					likeness = most_alike texts
					averageness = most_average texts
					console.log likeness
					console.log averageness
					# console.log 'tests passed!'