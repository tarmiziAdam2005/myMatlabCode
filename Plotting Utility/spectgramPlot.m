function spectgramPlot(~)
%Last Updated on 29/8/2013
%Created by Tarmizi Adam
%This code was created by Tarmizi Adam
%The code plots the time domain speech signal and its corresponding 
%spectrogram.

%Input: .wav file (speech)
%output: Plot of Time domain (speech) and Spectrogram 


[dir_waveFile, path] = uigetfile('*.wav','Load Wave File...');
path = [path, dir_waveFile];
[y,fs] = audioread(path); % older version of MATLAB uses wavread()

nStr = input('Do you want to add white noise to the audio?<y/n>: ','s')


if strcmp(nStr,'y')
    
    noiseLvl = input('Enter noise level in decibels (0-25dB): ');
    y2 = awgn(y,noiseLvl,'measured');
    N_noise = length(y2); %number of samples/no of discrete points
    t_noise = (0:N_noise-1)/fs; %time increment t = N/fs
    
    subplot(2,2,1)
    plot(t_noise,y,'black');
    axis tight;
    ylim([-1,1])
    
    subplot(2,2,2)
    plot(t_noise,y2,'black');
    axis tight;
    ylim([-1,1])
    
    subplot(2,2,3)
    colormap('gray');
    map = colormap;
    imap = flipud(map);
    M = round(0.016*fs); % 20 ms window
    W= 0.54-0.46*cos(2*pi*(0:M-1)/(M-1)); % Hamming window
    spectrogram(y,W,M/2,1024,fs); % plot spectrogram(x, window, noverlap,NFFT,fs)
                              %x = input speech, window function, size frame
                              %overlaps, FFT points, sampling rate.
    colormap(imap);
    view(-90,90); %rotate axis, because spectrogram() produces Freq vs Time
              % rather than Time vs Freq
    set(gca,'ydir','reverse') % reverse the time axis.

    subplot(2,2,4)
    colormap('gray');
    map = colormap;
    imap = flipud(map);
    M = round(0.016*fs); % 20 ms window
    W= 0.54-0.46*cos(2*pi*(0:M-1)/(M-1)); % Hamming window
    spectrogram(y2,W,M/2,1024,fs); % plot spectrogram(x, window, noverlap,NFFT,fs)
                              %x = input speech, window function, size frame
                              %overlaps, FFT points, sampling rate.
    colormap(imap);
    view(-90,90); %rotate axis, because spectrogram() produces Freq vs Time
              % rather than Time vs Freq
    set(gca,'ydir','reverse') % reverse the time axis.

    print(gcf,'-dpdf','-r300','spec'); % print output to pdf file.
    
    
elseif strcmp(nStr,'n')
    
    N = length(y); %number of samples/no of discrete points
    t = (0:N-1)/fs; %time increment t = N/fs
    
    subplot(2,1,1)
    plot(t,y,'black');
    axis tight;
    ylim([-1,1])
    
    subplot(2,1,2)
    colormap('gray');
    map = colormap;
    imap = flipud(map);
    M = round(0.016*fs); % 20 ms window
    W= 0.54-0.46*cos(2*pi*(0:M-1)/(M-1)); % Hamming window
    spectrogram(y,W,M/2,1024,fs); % plot spectrogram(x, window, noverlap,NFFT,fs)
                              %x = input speech, window function, size frame
                              %overlaps, FFT points, sampling rate.
    colormap(imap);
    view(-90,90); %rotate axis, because spectrogram() produces Freq vs Time
              % rather than Time vs Freq
    set(gca,'ydir','reverse') % reverse the time axis.
    
    print(gcf,'-dpdf','-r300','spec'); % print output to pdf file.
end

disp('End of function');
end
