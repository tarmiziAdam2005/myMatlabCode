
%---Updated on 21/2/2013---
%This peace of code is used to plot bar graphs.
%-----------------------
%---INPUT: Data from excel to be plotted
%---OUTPUT: Bar graph. Grouped bar graph or ungrouped bargraph.
%-------------------------------------------------------
%----Created by Tarmizi Adam for ease of plotting bar graph results.

%read excel data to plot
[FileName,PathName,FilterIndex] = uigetfile('*.xlsx','Load Excel spread sheet'); %Select an excel file

FileName = strcat(PathName,FileName); %path and filename of the excel file
[numDat,txtDat]=xlsread(FileName, -1);% read numberd data and string data from file

if (isempty(txtDat) == 0) %if text data is not empty with strings
toPlot = numDat(:,1:size(numDat,2)); %use this to plot 
else
    toPlot = numDat(:,2:size(numDat,2));
end
    
%========Input the Graph Title, x-axis title, and y-axis title======
graphTitle = input('Enter Graph Title: ','s')
xtitle = 'Coefficient Index' %input('Enter x-axis Title: ','s')
ytitle = 'Recognition Rate [%]'%input('Enter y-axis Title: ','s')

%========Legend title of the plot===============
legTitle = {'MFCC Speaker Dependent','MFCC Speaker Independent'};
%{
for i = 1:size(toPlot,2)
    legTitle{i}=input('Enter title of legend: ','s');
end
%}
%===========Output PDF file name================
outPdfFile = input('Print PDF file as:','s');

%===========Plot the bar graph=====================
bar((1:size(numDat,1)),toPlot,'Group');

if (isnumeric(numDat(:,1))== 1 && isempty(txtDat) == 0)
    
    set(gca,'XTick',1:length(txtDat),'XTickLabel',txtDat,'FontSize',20,'LineWidth',1.5);
else
     x = num2cell(numDat(:,1));
     set(gca,'XTick',1:length(x),'XTickLabel',x,'FontSize',20,'LineWidth',1.5);
end

xlabel(xtitle);
ylabel(ytitle);
title(graphTitle);
ylim([0 100]);
legTitle'; 
legend(legTitle);
grid on;

%====Some Color Options======
colormap(gray); %Color type
%shading faceted; %Shading effect

%==========Print PDF File====================
print(gcf,'-dpdf','-r300',outPdfFile);


%================DISCARDED codes=========================================

%if x-axis is noise use: 'Noise Level [SNR]'
%if x-axis is number of coefficients use: 'Coefficient Index' 


%Different legend titles
%legTitle = {'MFCC','WCC Coif5 lvl 5','WCC Db12 lvl 5'};
