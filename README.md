# LSM.js

An interface for using Language Style Matching to determine the likeness of different texts and their authors.

## Installation

	npm install lsm

## Usage

Initialize an LSM object with a text sample, and then use `compare` to compare it to other LSM objects, or `combine` to merge LSM objects.

Here we'll compare likeness based on two diaries:

	var LSM = require('lsm').LSM
	  // text samples
	  , my_text = require('./my_diary')
	  , your_text = require('./your_diary');
	  // lsm objects
	  , my_lsm = new LSM(my_text)
	  , your_lsm = new LSM(your_text);

	// your likeness: a number between 0 and 1, 
	// where 1 is identical and 0 is no similarity
	console.log(my_lsm.compare(your_lsm));

You can calculate likeness amongst groups by combining multiple LSM objects with `combine`.

	var other_text = require('./mountains_of_madness')
	  , other_lsm = new LSM(other_text)
	  , our_lsm = my_lsm.combine(your_lsm);

	// our combined likeness to a third text sample.
	console.log(our_lsm.compare(other_lsm));

## Testing

	npm test

## What is Language Style Matching?

Language Style Matching (LSM) uses function words -- like conjunctions, pronouns, prepositions, etc. -- as proxies for the author's personality. LSM calculates likeness between people and texts by comparing how much of a text function words constitute. 

In research, LSM has proven a resilient indicator of compatibility in romance, friendship, and business.

Read [the Economist's thoughts](http://www.economist.com/blogs/johnson/2010/10/language_style_matching) on it, or check out the science:

* [Language Style Matching Predicts Relationship Initiation and Stability](https://webspace.utexas.edu/pe2929/Eastwick/Ireland2011_PSci.pdf)
* [Language Style Matching in Writing: Synchrony in Essays, Correspondence, and Poetry](http://homepage.psy.utexas.edu/homepage/faculty/pennebaker/reprints/Ireland%26Pennebaker_JPSP2010.pdf)