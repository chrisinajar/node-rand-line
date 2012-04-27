var RandLine = require('./lib')

var rl = new RandLine('../ilTest/src/api/forecast_skus.txt');


var total = 0;
var objective = 5000;

console.log('Testing with ' + objective);

for (var i = 0; i < objective; ++i) {
	rl.line(function(d) {
		if (parseInt(d) < 1)
			throw new Error ('Fuck this noise')
	});
}
