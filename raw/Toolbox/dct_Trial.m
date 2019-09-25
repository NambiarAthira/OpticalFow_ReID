%%DCT TRIAL
close all;
clear all;
clc;

% x=0:1:15
y=[10 12 15 14 13 11 9 1 -5 -3 1 2 5 4 2 -2]
plot(y,'r-*')
grid on

d=dct(y)
figure;% stem(d/sqrt(length(y)/2)) % why different ans than http://datagenetics.com/blog/november32012/index.html
stem(d)
% df=fft(y)
% figure; stem(df/(length(y))) % why different ans than http://datagenetics.com/blog/november32012/index.html

inverse=idct(d)
figure; plot(inverse,'-*');grid on

% inverse2=idct(d,16)
% figure; plot(inverse2,'-*');grid on