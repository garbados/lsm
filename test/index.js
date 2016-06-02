var fs = require('fs');
var assert = require('assert');

var lib = require('../lib');

var text_1 = fs.readFileSync('data/sample_1.txt').toString();
var text_2 = fs.readFileSync('data/sample_2.txt').toString();
var text_3 = fs.readFileSync('data/sample_3.txt').toString();

describe('lsm', function () {
  it('should indicate identical samples have 100% likeness.', function () {
    var result = lib.compare(text_1, text_1);
    assert.equal(result, 1);
  });

  it('should compare dissimilar samples and report likeness.', function () {
    var result = lib.compare(text_1, text_2);
    assert.equal(result, 0.6211902592673091);
  });

  it('should compare dissimilar samples from different authors.', function () {
    var result = lib.compare(text_1, text_3);
    assert.equal(result, 0.47398288542787886);
    var result = lib.compare(text_2, text_3);
    assert.equal(result, 0.6620090589323643);

  });
});
