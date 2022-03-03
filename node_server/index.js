const websocket = require("ws");
const serverAddr = "ws://localhost:8080";
const ws = new websocket(serverAddr);

ws.on("open", function () {
  console.log("connected to server");
  ws.send("Hello Node MCU");
});

ws.on("message", function (msg) {
  console.log(msg);
});
