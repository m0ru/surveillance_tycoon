utils = {};

/*
utils.randomFloat = function(lower, upper) {
    return lower + Math.random() * (upper - lower)
}

utils.randomInt = function(lower, upper) {
    return Math.floor(utils.randomFloat(lower, upper+1));
}*/
utils.numberWithCommas = function(x) {
    x = x.toString();
    var pattern = /(-?\d+)(\d{3})/;
    while (pattern.test(x))
        x = x.replace(pattern, "$1,$2");
    return x;
}

module.exports = utils;
