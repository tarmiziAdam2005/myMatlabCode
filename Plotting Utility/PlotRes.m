
%---Updated on 21/2/2013---
%---Updated on 28/7/2015---
%   - Latest update Changed the code to plot lines instead of bar plots.

% USAGE: Only select numerical values in the excel file.

%This peace of code is used to plot lines.
%-----------------------
%---INPUT: Data from excel to be plotted
%---OUTPUT: Bar graph. Grouped bar graph or ungrouped bargraph.
%-------------------------------------------------------
%----Created by Tarmizi Adam for ease of plotting bar graph results.
clc
clear all;
close all;

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
xtitle = '\mu' %input('Enter x-axis Title: ','s')
ytitle = 'PSNR(dB)'%input('Enter y-axis Title: ','s')
%ytitle = 'SSIM';

%========Legend title of the plot===============
legTitle = {'K=1','K=2','K=3','K=4','K=5','K=6','K=7','K=8','K=9','K=10'};

%===========Output PDF file name================
outPdfFile = input('Print PDF file as:','s');

%===========Plot the graph=====================
p = plot((1:size(numDat,1)),toPlot,'LineWidth',1.5);

mrk={'o','s','*','.','+','x','^','<','>','p'}.'; % Graph Markers
set(p,{'marker'},mrk); % Use our Markers for our plots

if (isnumeric(numDat(:,1))== 1 && isempty(txtDat) == 0)
    
    set(gca,'XTick',1:length(txtDat),'XTickLabel',txtDat,'FontSize',20,'LineWidth',2.5);
else
     x = num2cell(numDat(:,1));
     set(gca,'XTick',1:length(x),'XTickLabel',x,'FontSize',20,'LineWidth',2.5);
end

%Set the printing command as to print our graph region only.
%If these are not set, the graph will be in the center of an A4 size page
%set(gcf,'Units','Inches');
%pos = get(gcf,'Position');
%set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])


xlabel(xtitle);
ylabel(ytitle);
title(graphTitle);

%===========Can use this to specify axis of x and y==============
%ylim([15 35]);
%xlim([0 25])

%============Can also use this to specify the limits of x and y axis====

%axis([0 25 15 35]);

legTitle';
%legend(legTitle);
legend(legTitle,'Location','southeastoutside','FontSize',9); %Legend at bottom right
grid on;

%====Some Color Options======
colormap(gray); %Color type
%shading faceted; %Shading effect


%==========Print PDF File====================
print(gcf,'-dpdf','-r300',outPdfFile);



