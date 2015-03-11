function Normalized = Normalize(mfcc)


N= length(mfcc);

Mean = mean(mfcc); %Mean
stdeviation = std(mfcc); %Standard Deviation

 Normalized = (mfcc(1:N) - Mean)/stdeviation; %Normalization formula 
                                 % from Daqrouq 2011
