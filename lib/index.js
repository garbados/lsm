var pos = require('pos');
var lexer = new pos.Lexer();
var tagger = new pos.Tagger();
var fwords = require('./fwords.json');

/**
 * A formula for calculating a weighted difference score between two values,
 * modified to prevent division by zero.
 * As described in 'Molly E. Ireland and James W. Pennebaker, University of Texas at Austin, 2010'
 * @param  {Number} n1
 * @param  {Number} n2
 * @return {Number}
 */
function abs_diff_score (n1, n2) {
  return 1 - (Math.abs(n1 - n2) / (n1 + n2 + Number.MIN_VALUE));
}

/**
 * [lex_and_tag description]
 * @param  {String} text A language sample to lex and tag
 * @return {Array}       A list of all tags found in the text
 */
function lex_and_tag (text) {
  var words = lexer.lex(text);
  var tags = tagger.tag(words);
  return tags.map(function (tag) {
    return tag[1];
  });
}

/**
 * Like Python's Counter datatype, converts an array into an object
 * where each key is a term from the array,
 * and each value is the number of times that term appeared in the array.
 * @param  {Array} list List of strings
 * @return {Object}
 */
function get_counts (list) {
  var counter = {};
  list.forEach(function (item) {
    if (counter[item]) {
      counter[item] += 1;
    } else {
      counter[item] = 1;
    }
  });
  return counter;
}

function get_fword_proportion (text) {
  var tags = lex_and_tag(text);
  var counts = get_counts(tags);
  var total_count = 0;
  var fword_counts = {};
  Object.keys(counts).forEach(function (key) {
    total_count += counts[key];
    if (fwords.indexOf(key) !== -1) {
      fword_counts[key] = counts[key];
    }
  });
  var fword_proportions = {};
  Object.keys(fword_counts).forEach(function (key) {
    fword_proportions[key] = fword_counts[key] / total_count;
  });
  return fword_proportions;
}

function compare_fword_proportions (f1, f2) {
  var likeness = [];
  fwords.forEach(function (key) {
    if ((f1[key] === undefined) || (f2[key] === undefined)) {
      if ((f1[key] === undefined) && (f2[key] === undefined)) {
        // do nothing, nothing to compare
      } else {
        likeness.push(0);
      }
    } else if (f1[key] === f2[key]) {
      likeness.push(1);
    } else {
      var weight = Math.abs(1 - ((f1[key] + f2[key])/2));
      var diff = abs_diff_score(f1[key], f2[key]);
      likeness.push(diff * weight);
    }
  });
  if (likeness.length) {
    var sum = likeness.reduce(function (a, b) { return a + b; });
    var avg = sum / likeness.length;
    return avg;
  } else {
    return 0;
  }
}

function compare_text_samples (t1, t2) {
  var result = [t1, t2].map(get_fword_proportion);
  return compare_fword_proportions.apply(null, result);
}

module.exports = {
  compare: compare_text_samples
};
