function [s, flag] = setupSerial(comPort)
s = serial(comPort);
set(s, 'DataBits', 8);
set(s, 'StopBits', 1);
set(s, 'BaudRate', 9600);
set(s, 'Parity', 'none');
fopen(s);

c = 'b';
while (c ~= 'c')
    c = fread(s, 1, 'uchar');
end

if (c =='c')
    disp('serial read');
end

fprintf(s, '%c', 'c');
flag = 1;
disp('Serial Com Setup');
fscanf(s, '%u');

end