a = arduino('COM13', 'Mega2560', 'Libraries', 'Serial');
serial1 = device(a,'SerialPort',1, 'BaudRate',115200);
serial1.write("haha");
