close all
clc

fs = 80  % sample frequency
t= 0:1/fs:1; % time interval

x = 1+ 2*sin(2*pi*3*t)+ 1.5*cos(2*pi*2*t); % input signal


subplot(4,1,1)
stem(t,x);
xlabel('time');
ylabel('value');
axis([0 1 -4 6])
title('Sampling signal'); %plot of the input signal


en = [] % array to store binary data
qx=[] %stores the quantized values of the signal
for i=1:length(x) % dividing the signals into levels(3 bit)
    if(x(i)>3 && x(i)<=4)  % maximum amplitude of the signal is 4 and minimum is -3
        qx(i)= 3.5;
        e = [0 0 0];
    elseif(x(i)>2 && x(i)<=3)
        qx(i)= 2.5;
        e = [0 0 1];        
    elseif(x(i)>1 && x(i)<=2)
        qx(i)=1.5;
        e=[0 1 0];
    elseif(x(i)>0 && x(i)<=1)
        qx(i) = 0.5;
        e= [0 1 1];
    elseif(x(i)>-1 && x(i)<=0)
        qx(i)= -0.5;
        e= [1 0 0];
    elseif(x(i)>-2 && x(i)<=-1)
        qx(i)= -1.5;
        e=[1 0 1];
    else(x(i)>-3 && x(i)<=-2)
        qx(i) = -2.5;
        e= [1 1 0];
    end
    en = [en e];
end

subplot(4,1,2)
stem(t,x);hold on
axis([0 1 -4 6])
plot(t,qx); % plot of quantized values
title('quantized signal')
 % encoded signal is transmitted ( array 'en')
%decode of binary data
Xd = [] 
for i=1:3:length(en)-2
    if(en(i)==0 && en(i+1)==0 && en(i+2)==0)
        xd= 3.5;
    elseif(en(i)==0 && en(i+1)==0 && en(i+2)==1)
        xd = 2.5;
    elseif(en(i)==0 && en(i+1)==1 && en(i+2)==0)
        xd= 1.5;
    elseif(en(i)==0 && en(i+1)==1 && en(i+2)==1)
        xd = 0.5;
    elseif(en(i)==1 && en(i+1)==0 && en(i+2)==0)
        xd = -0.5;
    elseif(en(i)==1 && en(i+1)==0 && en(i+2)==1)
        xd = -1.5;
    else(en(i)==1 && en(i+1)==1 && en(i+2)==0)
        xd = -2.5;
    end
    Xd = [Xd xd]; 
end
subplot(4,1,3)
plot(t,Xd)
axis([0 1 -4 6])
title('decoded quantized signal') %plot of decoded quantized values

[a b]= butter(2,3*3/fs); % lowpass filter
finalXd = filter(a,b,Xd);
subplot(4,1,4)
plot(t,finalXd)
axis([0 1 -4 6])
title('after passing through low pass filter') % decoded signal