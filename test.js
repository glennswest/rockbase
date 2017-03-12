var faker = require("faker");
var util = require("util");

console.log(faker.fake("{{name.lastName}}, {{name.firstName}} {{name.suffix}}"));

console.log(util.inspect(faker.helpers.createCard()));


