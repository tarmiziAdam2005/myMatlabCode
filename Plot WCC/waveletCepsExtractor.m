[fileName, pathName, filterIndex] = uigetfile('*.wav','Wav files (*.wav)','Select File', 'MultiSelect','on'); % Opens a dialog box to select file
fileName = cellstr(fileName);

%X = zeros(length(fileName),200);
for k =1:length(fileName)
thisFullName = fullfile(pathName,fileName{k}); %create the directory of the selected file
%[y,fs,nbits] = wavread(thisFullName); % read the selected '.wav' file

wObj = waveFile2obj(thisFullName)

epdParam=epdPrmSet(wObj.fs);
ep = epdByVolHod(wObj,epdParam, 0);
y2=wObj.signal(ep(1,1):ep(1,2));



X(k,1:800) = Feature_Extraction(y2);


end

TRAIN = X;
TEST = X;

clear X;

%--------Save X--------------------
[fileName,pathName,filterIndex] = uiputfile('*.mat','Save wavelet coef training features','WAVELET_TRAIN');

if (filterIndex == 1)
  
simpan = [pathName,fileName];
save(simpan,'TRAIN');

else
%---------Save Y----------------------
[fileName,pathName] = uiputfile('*.mat','Save wavelet coef test features','WAVELET_TEST');
simpan = [pathName,fileName];
save(simpan,'TEST');
end

