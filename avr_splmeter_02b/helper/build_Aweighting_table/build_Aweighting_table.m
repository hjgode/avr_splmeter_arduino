% Build A-weighting filter gain table used to filter signal
% 
% copyright (c) Davide Gironi, 2013
% 
% Released under GPLv3.
% Please refer to LICENSE file for licensing information.

%clear matlab workspace
clear;

%build the filter using fdesign
Fsf = 22050; %frequency used for filter creation
HawfA = fdesign.audioweighting('WT,Class','A',1,Fsf);
Afilter = design(HawfA);
%plot filter 1
%get filter freq resp
[AH, AW] = freqz(Afilter);
%plot filter
figure(1)
semilogx(AW*1000,20*log10(abs(AH)));
xlabel('Frequency [Hz]'); ylabel('Gain [dB]');
title(['A-weighting, Fs = ',int2str(Fsf),' Hz']);
legend('Filter');
grid on

%gaintable size
gaintablesize = 32;

%build filter gaintable
WindowSize = gaintablesize*2; %samples for gaintable creation / window length
filter_gaintable = freqz(Afilter, WindowSize, 'whole'); %built for the sized window
filter_gaintableR = real(filter_gaintable);
filter_gaintableI = imag(filter_gaintable);

%build test signal
Fs = 22050; %sampling frequency of signal
T = 1/Fs; %sample time
L = WindowSize*20; %length of signal (20 * window)
t = (0:L-1)*T; %time vector
y = 0.7*sin(2*pi*50*t) + sin(2*pi*2000*t) + 2*randn(size(t)); %sum of a 50Hz and a 2000 Hz sinusoid plus noise
signal = y';

%estimate signal level (within each windowed segment).
windowIntervals = [1:WindowSize:(length(signal)-WindowSize)];
windowTime = t(windowIntervals+round((WindowSize-1)/2));
%will contain the full signal
signalT = [];
filteredsignalT = [];
filteredsignalfreqrespT = [];
%will contain the dBA computations
dBA1 = zeros(length(windowIntervals),1);
dBA2 = zeros(length(windowIntervals),1);
dBA3 = zeros(length(windowIntervals),1);
for i = [1:length(windowIntervals)]
	%take a part of the signal
    signalP = signal(windowIntervals(i)-1+[1:WindowSize]);
    
    %filter signal part by filter function
    filteredsignalP = filter(Afilter, signalP);
    
    %filter signal part by frequency response 
    NFFTP = length(signalP);
    fftsignalP = fft(signalP);
    fftfilteredsignalP = fftsignalP .* filter_gaintable;
    filteredsignalfreqrespP = ifft(fftfilteredsignalP, NFFTP);
    
    %built the full signal
    signalT = cat(1, signalT, signalP);
    filteredsignalT = cat(1, filteredsignalT, filteredsignalP);
    filteredsignalfreqrespT = cat(1, filteredsignalfreqrespT, filteredsignalfreqrespP);
    
    %calcuatate rms of the signal part
    rmssignalP = sqrt(mean(signalP.^2));
    rmsfilteredsignalP = sqrt(mean(filteredsignalP.^2));
    rmsfilteredsignalfreqrespP = sqrt(mean(filteredsignalfreqrespP.^2));
    
    % Estimate dBA value using Parseval's relation.
    dBA1(i) = 20*log10(rmssignalP);
    dBA2(i) = 20*log10(rmsfilteredsignalP);
    dBA3(i) = 20*log10(rmsfilteredsignalfreqrespP);
end

% %plot full signal, and filtered signal
% figure(2)
% plot([1:length(signalT)], signalT, '-', [1:length(filteredsignalT)], filteredsignalT, '-', [1:length(filteredsignalfreqrespT)], filteredsignalfreqrespT);
% title(['compare signal (1 window), to filtered signal']);
% legend('signal', 'filtered (using filter function)', 'filtered (using response table)');
% grid on

%plot out results
figure(3)
plot([1:length(dBA1)],dBA1,'-',[1:length(dBA2)],dBA2,'-',[1:length(dBA3)],dBA3);
legend('dBA signal','dBA filtered (using filter function)', 'dBA filtered (using weight table)',3);
grid on

%save gaintable to xls
CR(:,1) = filter_gaintableR(1:length(filter_gaintableR)/2); %retain frequencies below Nyquist rate
CI(:,1) = filter_gaintableI(1:length(filter_gaintableI)/2); %retain frequencies below Nyquist rate
M = xlswrite('aweightingtableR.xls', CR);
M = xlswrite('aweightingtableI.xls', CI);
