# LSM

An interface for using Language Style Matching to determine the likeness of different texts and their authors.

## Installation

	npm install lsm

## Usage

```javascript
var LSM = require('lsm');

var text_1 = "In my younger and more vulnerable years my father gave me some advice that I've been turning over in my mind ever since.
\"Whenever you feel like criticizing any one,\" he told me, \"just remember that all the people in this world haven't had the advantages that you've had.\"";

var text_2 = "I'm a romantic; a sentimental person thinks things will last, a romantic person hopes against hope that they won't.";

var result = LSM.compare(text_1, text_2);
console.log(result);
// 0.6211902592673091
```

A likeness value of 1 indicates that the compared samples are *identical* in their proportions of function words. A value of 0 indicates total dissimilarity.

## Testing

	npm test

The samples used to test LSM were extracted from Imogen Binnie's [Nevada](http://haveyoureadnevada.com/) and Torrey Peter's [The Masker](http://www.torreypeters.com/book/the-masker/).

## What is Language Style Matching?

Language Style Matching (LSM) uses function words -- like conjunctions, pronouns, prepositions, etc. -- as proxies for the author's personality. LSM calculates likeness between texts by comparing the proportions of different classes of function words.

In research, LSM has proven a resilient indicator of compatibility in romance, friendship, and business.

Read [the Economist's thoughts](http://www.economist.com/blogs/johnson/2010/10/language_style_matching) on it, or check out the science:

* [Language Style Matching Predicts Relationship Initiation and Stability](https://webspace.utexas.edu/pe2929/Eastwick/Ireland2011_PSci.pdf)
* [Language Style Matching in Writing: Synchrony in Essays, Correspondence, and Poetry](http://homepage.psy.utexas.edu/homepage/faculty/pennebaker/reprints/Ireland%26Pennebaker_JPSP2010.pdf)

## License

