var spread_sheet = require("spread_sheet");
var row = ["1", "2", "Jack", "Pirate"];
var filePath = "test.xlsx";
var sheetName = "Sheet1";

spread_sheet.addRow(row, filePath, sheetName, function (err, result) {
  console.log(err, result);
});
