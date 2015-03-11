% This function extracts the MFCC from the ".wav" file and converts the 
% the feature into a (1 x N) feature vector.
% This function also calls the ZeroPadding function to perform zero
% padding of the features

%=========================================================================
%            This function extracts WAVELET CEPSTRUM features
%            at level 3 of discrete wavelet transform coefficients
%=========================================================================

% created on 28/10/2011

function wavelet_ceps = Feature_Extraction(y)

y = Normalize(y);
yEmphasis = filter([1,-0.95],1,y); % Pre-emphasis filter to the signal
yFramed = buffer2(yEmphasis,256,128); % Frame the signal into chunks

for i=1:size(yFramed,2)
    %-----------Hamming Windowing-----------------------
    yWindowed(:,i) = hamming(256).*yFramed(:,i); % Hamming windowing
    
    %------------Wavelet transform up to level 3-----------
    [C(:,i),L(:,i)]= wavedec(yWindowed(:,i),8,'db8'); % Wavelet transform
    
    %-------------Extract approximate and detail coefficients---------
    a5(:,i) = appcoef(C(:,i),L(:,i),'db8',5); %Extracting approximate coef at lvl 3
    d5(:,i) = detcoef(C(:,i),L(:,i),5); % Extracting detailed coef at lvl 3
    d4(:,i) = detcoef(C(:,i),L(:,i),4);
    d3(:,i) = detcoef(C(:,i),L(:,i),3);
    %d5(:,i) = detcoef(C(:,i),L(:,i),5);
    
    %---------------Calculate the log power spectrum of the coefficients-----
    energyWaveletCoef(:,i) = log(abs(fft(a5(:,i)))); 
    energyWaveletCoef2(:,i) = log(abs(fft(d5(:,i))));
    energyWaveletCoef3(:,i) = log(abs(fft(d4(:,i))));
    energyWaveletCoef4(:,i) = log(abs(fft(d3(:,i))));
    %energyWaveletCoef5(:,i) = log(abs(fft(d5(:,i))));
    %-----------Discrete cosine transform---------------------
    waveletCepst(:,i) = dct(energyWaveletCoef(:,i));
    waveletCepst2(:,i) = dct(energyWaveletCoef2(:,i));
    waveletCepst3(:,i) = dct(energyWaveletCoef3(:,i));
    waveletCepst4(:,i) = dct(energyWaveletCoef4(:,i));
    %waveletCepst5(:,i) = dct(energyWaveletCoef5(:,i));
   
end

a = waveletCepst(1:10,:); % take only 10 wavelet cepstrum for every frame
b = waveletCepst2(1:10,:);% take only 10 wavelet cepstrum for every frame
c = waveletCepst3(1:10,:);
d = waveletCepst4(1:10,:);
%e = waveletCepst5(1:10,:);

wavelet_ceps = vertcat(a,b,c,d); % Concatenate the two wavelet cepstrum

wavelet_ceps = wavelet_ceps(:)'; % transform into column only marix

wavelet_ceps = ZeroPadding(wavelet_ceps); %zero padding to 800 features

maxVal = max(abs(wavelet_ceps)); % find the absolute maximum in the vector

wavelet_ceps = wavelet_ceps/maxVal; % Normalize between (-1 and 1)
% End of function




