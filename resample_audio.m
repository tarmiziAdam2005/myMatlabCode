function resample_audio( ~ )
%RESAMPLE_AUDIO Summary of this function goes here
% Function to read an audio file and resample to 16kHz
% Input: Audio file
% Output: Mono Audio file
% 28/8/2013
%   Detailed explanation goes here

[dir_waveFile, path] = uigetfile('*.wav','Load Wave File...');
path = [path, dir_waveFile];
y = audioread(path);

if(size(y,2)==2)
    
    disp('Stereo audio loaded')
    str = input('Enter ".wav" file name: ','s');
    disp('Converting to mono...')
    
    mono_audio = (y(:,1)+y(:,2))/2; %Convert a setreo audio into mono
    audiowrite([str,'.wav'],mono_audio,16000);
    
elseif(size(y,2)==1)
    
    disp('Modo audio loaded')
   
end

disp('End of function');

end

