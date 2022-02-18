const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  var connection = new WebSocket("ws://" + location.hostname + ":81/");

  connection.onmessage = function (event) {
    var full_data = event.data;
    console.log(full_data);
    var data = JSON.parse(full_data);
    IMU_data = data.IMU;
    console.log(IMU_data);
    document.getElementById("IMU_value").innerHTML = IMU_data;
  };
  res.send("Hello World!");
});

app.listen(3000, () => {
  console.log(`Example app listening on port ${3000}`);
});
