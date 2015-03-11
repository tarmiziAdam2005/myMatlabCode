function addAudioNoise(~)
%ADDBABBLENOISE Summary of this function goes here
%   Detailed explanation goes here

[dir_cleanWaveFile, cleanPath] = uigetfile('*.wav','Load clean Wave Files...','MultiSelect','on');
dir_cleanWaveFile = dir_cleanWaveFile';

[dir_noisyWaveFile, noisyPath]=uigetfile('*.wav','Load noisy Wave Files...','MultiSelect','on');
dir_noisyWaveFile =dir_noisyWaveFile';

saveFolder = uigetdir('C:\Users\ASUS\Desktop', 'Select directory to save file...');

for i=1:size(dir_cleanWaveFile,1)
    x = randi([1,length(dir_noisyWaveFile)])% random babble noise file to add with clean speech
    
    cleanAudio = audioread([cleanPath, dir_cleanWaveFile{i,1}]); %Read celan audio
    noisyAudio = audioread([noisyPath, dir_noisyWaveFile{x,1}]); %Read babble noise audio
    
    if length(noisyAudio)<length(cleanAudio)                % check if the noisy babble audio length is samaller then clan audio. if Yes
        noisyAudio(end+1:length(cleanAudio))=0;             %zero pad the noise audio. Because audio addition must be same vector length
        
        noisyAudio = cleanAudio + noisyAudio;                %Add the two audio files (Bbabble noise and Clean speech)
        
        audiowrite([saveFolder,'\',dir_cleanWaveFile{i,1}],noisyAudio,16000); %Write the newly created audio file
        
    elseif length(noisyAudio)>length(cleanAudio)            %Check if the noisy babble audio length is larger than clean speech audio. if Yes;
        noisyAudio = noisyAudio(1:length(cleanAudio));      %truncate the noise audio.
        
        noisyAudio = cleanAudio + noisyAudio;               % Add the two corresponding audio files
        audiowrite([saveFolder,'\',dir_cleanWaveFile{i,1}],noisyAudio,16000);%Write the newly created audio file
        
     elseif length(noisyAudio)==length(cleanAudio)
        noisyAudio = cleanAudio + noisyAudio; 
        audiowrite([saveFolder,'\',dir_cleanWaveFile{i,1}],noisyAudio,16000); 
        
    end
    
end

disp('End of function. Exiting...')
end

