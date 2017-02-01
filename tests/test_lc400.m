[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Add nPoint packate
addpath(genpath(fullfile(cDirThis, '..')));

lc400 = nPoint.LC400.LC400();
lc400.init();
lc400.connect();
lc400.s.BaudRate
lc400.s.Terminator
lc400.getRange(1)


% Test

cAddress = hex.Utils.add(lc400.addrCh1Base, lc400.offsetRange);
 
lc400.readSingle([cAddress; cAddress], ['int32'; 'int32'])


%{
d = lc400.getWavetables(10000);
figure
hold on
plot(d(1, :), 'r');
plot(d(2, :), 'b');
legend({'ch 1', 'ch 2'});



%}

lc400.setTwoWavetablesActive(false);

period = 100e-3;
clock = 24e-6;
t = 0: clock : period;
f = 1/period;
a = 0.3;
x = a * sin(2 * pi * t * f);
y = a * cos(2 * pi * t * f);

% Bin to 20-bit [-524287 : +524287]

xInt = int32(x * (2^20 - 2) / 2);
yInt = int32(y * (2^20 - 2) / 2);


figure
subplot(121)
hold on
plot(t, xInt, 'r')
plot(t, yInt, 'b');

lc400.setWavetable(uint8(1), xInt');
lc400.setWavetable(uint8(2), yInt');

w = lc400.getWavetables(uint32(length(t)));

subplot(122)
hold on
plot(t, w(1, :), 'r')
plot(t, w(2, :), 'b')


lc400.setWavetableEnable(1, true);
lc400.setWavetableEnable(2, true);
lc400.setTwoWavetablesActive(true);


d = lc400.recordRaw(uint32(length(t)));
figure
hold on
plot(d(1, :), 'r');
plot(d(2, :), 'b');
plot(d(3, :), 'g');
plot(d(4, :), 'y');
legend({...
    'ch 1 cmd', ...
    'ch 1 sensor', ...
    'ch 2 cmd', ...
    'ch 2 sensor' ...
});

lc400.setTwoWavetablesActive(false);




