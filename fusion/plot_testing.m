tp = theaterPlot('XLimit',[-2 2],'YLimit',[-2 2],'ZLimit',[-2 2]);
op = orientationPlotter(tp,'DisplayName','Fused Data',...
    'LocalAxesLength',2);

while 1
    figure
x = linspace(0,10);
y1 = sin(x);
plot(x,y1)
plotOrientation(op, 90, 10, 10);
title('Orientation Plot')
end



