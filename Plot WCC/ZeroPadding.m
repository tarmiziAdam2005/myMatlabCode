function padded = ZeroPadding(mfcc)

FixSize =800;
N = length(mfcc);

if (N > FixSize)
    %for n = 1:FixSize
        %padded = mfcc(n+1);
    %end
    padded = mfcc(1:FixSize); %Truncate so that padded feature is equal
                              % to FixSize if the feature is larger than 
                              % FixSize.
end
if (N <FixSize)
     padded = mfcc(1:N);
     padded(N+1:FixSize) = 0; %Pad with "0" the feature vector if its less than the
                              % value of FixSize.
end

if (N==FixSize)
    
    padded = mfcc(1:N);
end