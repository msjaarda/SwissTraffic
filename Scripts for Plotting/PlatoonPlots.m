% Plot Platoon Results in AGB Format

% Initial Commands
clear, clc, close all

% Load data
addpath('./Results Variables/')

% INPUT ---------------

%PlotMAT = true;
%PlotMargins = false;
% Plot toggles (1 through 4 are 2.5m 5m 7.5m 10m)
MATPlots = [1 2 3 4];
%PlotCeneri = false;

% Legend labels
J{1} = '2.5 m'; J{2} = '5.0 m';  J{3} = '7.5 m'; 
J{4} = '10.0 m'; %J{5} = 'MSim'; J{6} = 'Cen 18';
%J{7} = 'Cen 18 10x Traf';

% Initialize vector for calculating accuracy
%Acc = [];

%Fig = 4.2; %or 'Custom' and fill out lower down details
%Fig = 4.2:0.1:4.6;

% INPUT OVER ----------

% Custom Input

% Set Plot Parameters
Section = 'Box'; % Box, Twin, TwinRed, TwinExp, TwinConc
Config = 'Mo';   % Bi, Mo
Dist = 'ExFast'; % Split, Stand, ExFast, ExSlow

% Set Location
Loc = 'Ceneri2017';

% Set Action Effects
AE{1} = 'Mn'; AE{2} = 'Mp'; AE{3} = 'V';
% Set Titles
Title{1} = 'M-'; Title{2} = 'M+'; Title{3} = 'V';

% Set Platoon Size
PlatSize{1} = 'S2'; PlatSize{2} = 'M3'; PlatSize{3} = 'L4';
w = 1;
PlatSizeNum = 2:4;

% Set Platoon Rate
PlatRate{1} = 'L20'; PlatRate{2} = 'H40';
r = 1;
PlatRateNum = [0.2 0.4];

% Set Plot Parameters
% Set Intervehicle Distance
IVD{1} = 'SMax'; IVD{2} = 'MSMax'; IVD{3} = 'MLMax'; IVD{4} = 'LMax';
%IVD{1} = 'SMean'; IVD{2} = 'MSMean'; IVD{3} = 'MLMean'; IVD{4} = 'LMean';
IVDnum = 2.5:2.5:10;
% Set Colors
Col{1} = [0.9100 0.4100 0.1700]; Col{2} = [0.2745 0.6863 0.8902];
Col{3} = [0.2745 0.8314 0.1922]; Col{4} = [0.6 0.6 0.6];

% Set Plot Size Parameters
MSize = 5; LWid = 1; Xmin = 20;

for r = 1:2

for w = 1:3

% Assign Figure Name
FName = sprintf('Figure 1 Box Girder, Unidirectional, %i-Truck Platoons at %i%%',w+1,PlatRateNum(r)*100);

% Load AGBMAT Results
%load('AGBResults.mat') % AGB.(Section).(Config).(Dist).(AE)
% Load AGB Results
%load('AGBMATResultsf50k.mat') % AGBMAT.(Sectionx).(Configx).(Distx).(AEx)
%MAT2 = MAT;
%load('AGBMATResults.mat')

load('PLATResults.mat')  
%PLAT.(Section).(Dist).(Loc).(PlatSize).(PlatRate).(AE).(IVD)(Span/20)
load('Ceneri2017Results.mat')


% For each figure
%for k = 1:length(Fig)
k = 1;

% Get Figure Details if input isn't custom
% if Fig(k) == 4.2 || Fig(k) == 4.3 || Fig(k) == 4.4 || Fig(k) == 4.5 || Fig(k) == 4.6 
%     [FName,Section,Config,Dist,AE,Title] = AGBFigDets(Fig(k));
% end

% Convert to cellular if necessary
if ~iscell(Section)
    temp = Section; clear Section; [Section{1:3}] = deal(temp);
end
if ~iscell(AE)
    temp = AE; clear AE; [AE{1:3}] = deal(temp);
end
if ~iscell(Dist)
    temp = Dist; clear Dist; [Dist{1:3}] = deal(temp);
end
if ~iscell(Loc)
    temp = Loc; clear Loc; [Loc{1:3}] = deal(temp);
end

% Initialize Figure
figure('Name',FName,'NumberTitle','off')

for i = 1:3 % for each subplot
%     if PlotMargins
%         subplot(2,3,i)
%     else
        subplot(1,3,i)
%     end
    
    % Get X/Y data
    X = 20:20:80; X = X';
    Y = PLAT.(Section{i}).(Dist{i}).(Loc{i}).(PlatSize{w}).(PlatRate{r}).(AE{i});
    Yx = MAT.(Section{i}).(Config).(Dist{i}).(AE{i});
    
    Inds = [2 4 6 8];
    plot(X(Inds),Yx.(Loc{3})(Inds)./Yx.E(Inds),'-s','Color',[0 0 0],'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0],'MarkerSize',MSize)

    %if PlotMAT
        %Yx = PLAT.(Section{i}).(Config).(Dist{i}).(AE{i});
        %Yx2= MAT2.(Section{i}).(Config).(Dist{i}).(AE{i});
    %end
    
    for j = MATPlots % for each traffic case... take away || if no MC
%         if j == MATPlots(length(MATPlots)) || j == MATPlots(length(MATPlots)-1)%  || j == MATPlots(length(MATPlots)-2)
%             HV = 'on';
%         else % Turn on or off legend visibility
%             HV = 'off';
%         end
%         if j == 4
%             scale = 1;
%         else % scale is a scaling factor to account for gamma model
%             scale = 1.1;
%         end
        hold on
        
        % Get only indices that have results
        Inds = ~isnan(Y.(IVD{j})) & X >= Xmin;
        plot(X(Inds),Y.(IVD{j})(Inds)./Y.BaseMax(Inds),'-s','Color',Col{j},'MarkerEdgeColor','none','MarkerFaceColor',Col{j},'MarkerSize',MSize)

%         if PlotMAT
%             if j == 5
%                 Inds = ~isnan(Yx.(IVD{j})) & X >= Xmin;
%                 MFC = 'k';
%             else
%                 MFC = 'none';
%             end
%             if j == 6
%                 MEC = 'r';
%             else
%                 MEC = 'k';
%             end                
%             hold on
%             plot(X,Yx.(IVD{j})./Yx.E,'-s','Color',Col{j},'MarkerEdgeColor',MEC,'MarkerFaceColor',Col{j},'MarkerSize',MSize,'HandleVisibility',HV)
%             plot(X,Yx2.(IVD{j})./Yx.E,'-s','Color','k','MarkerEdgeColor',MEC,'MarkerFaceColor',MFC,'MarkerSize',MSize,'HandleVisibility',HV)
%             %bp = zeros(1,size(X,1));
%             %bp(Inds') = [Y.(Loc{j})(Inds)*scale]./[Yx.(Loc{j})(Inds)];
%             % Acc is accuracy of MATSim compared to TM
%             %Acc = [Acc; bp];
%         end
    end
    % Track which of the traffic cases was the highest, for use in
    % Margin Plot
%     if strcmp(Section{i},'Box')
%         alphasq = 0.5;
%     else
%         alphasq = 0.4;
%     end
%     Esimmax = max([Y.GD'; Y.MD'; Y.DD'; Y.DetD']);
%     Eupdated = 1.5/1.1*(0.7*Y.EQ1 + 0.5*Y.EQ2 + alphasq*Y.Eq);
%     % Optional below: Yx or Y
%     if AlwaysTME
%         Eupdatedx = 1.5*(0.7*Y.EQ1 + 0.5*Y.EQ2 + alphasq*Y.Eq);
%     else
%         Eupdatedx = 1.5*(0.7*Yx.EQ1 + 0.5*Yx.EQ2 + alphasq*Yx.Eq);
%     end
%     M = Eupdated./Esimmax'-1;
%     if PlotMAT
%         Esimmaxx = max([Yx.GD'; Yx.MD'; Yx.DD'; Yx.DetD']);
%         %Esimmaxx2 = max([Yx.GD'; Yx.MD'; Yx.DD'; Yx.DetD'; Yx.CD']);
%         %Esimmaxx3 = max([Yx.GD'; Yx.MD'; Yx.DD'; Yx.DetD'; Yx.xTCD']);
%         Mx = Eupdatedx./Esimmaxx'-1;
%         %Mx2 = Eupdatedx./Esimmaxx2'-1;
%         %Mx3 = Eupdatedx./Esimmaxx3'-1;
%     end
    
    % Set tick details
    ytickformat('%.2f'); yticks(0.9:0.1:1.4); xticks(Xmin:20:80); set(gca,'TickDir','out'); set(gca,'YGrid','on')
    
    % Axis labels
    xlabel('Span (m)')
    
    % Set title
    title(Title{i})
    
    % Set axis limits
    ylim([0.9 1.4]); xlim([Xmin 80])

    % get handle of current, set box property to off and remove background color
    a = gca; set(a,'box','off','color','none');
    % create new, empty axes with box but without ticks
    b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[]);
    % set original axes as active, and link axes in case of zooming
    axes(a); %linkaxes([a b]);    
    
    
    if i == 1
        %ylabel('E_{SIM}/E_{SIA}')
        ylabel('E_{PLATSIM}/E_{BASESIM}')
        yh = get(gca,'ylabel'); % handle to the label object
        p = get(yh,'position'); % get the current position property
        p(1) = 0.9*p(1);          % double the distance,
        % negative values put the label below the axis
        set(yh,'position',p)   % set the new position
    end
    
%     if i == 1
%         if PlotMargins
%             %legend(J([1 2 3 4 5 6]),'Orientation','horizontal','Position',[0.155677121172981 0.496963062747592 0.701428561380931 0.0242857137322425]);
%         else
             legend(J([1 2 3 4]));
%         end
%     end
    
%     if PlotMargins
%     
%         subplot(2,3,i+3)
%         fill([0 0 30 50 80 80 0],[0 0.2 0.2 0.1 0.1 0 0],[0.8 0.8 0.8],'EdgeColor','none','LineWidth',1.5);
%         hold on
%         Inds = M > 0;
%         plot(X(Inds),M(Inds),'-s','Color','r','MarkerEdgeColor','none','MarkerFaceColor','r','MarkerSize',MSize)
%         % Set tick details
%         ytickformat('%.2f'); xticks(Xmin:10:80); set(gca,'TickDir','out'); set(gca,'YGrid','on')
%         % get handle of current, set box property to off and remove background color
%         a = gca; set(a,'box','off','color','none');
%         % create new, empty axes with box but without ticks
%         b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[]);
%         % set original axes as active, and link axes in case of zooming
%         axes(a); linkaxes([a b]);
%         
%         % Set axis limits
%         ylim([0 0.5]); xlim([Xmin 80])
%         xlabel('Span (m)')
%         if i == 1
%             ylabel('Margin')
%             yh = get(gca,'ylabel'); % handle to the label object
%             p = get(yh,'position'); % get the current position property
%             p(1) = 0.9*p(1);          % double the distance,
%             % negative values put the label below the axis
%             set(yh,'position',p)   % set the new position
%         end
%         
%         title([Title{i}])
%         
%                
%         if PlotMAT
%             hold on
%             Inds = [false true true true true true true true]';
%             plot(X(Inds),Mx(Inds),'-s','Color','k','MarkerEdgeColor','k','MarkerFaceColor','none','MarkerSize',MSize) 
%             %plot(X(Inds),Mx2(Inds),'-s','Color','k','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',MSize) 
%             %plot(X(Inds),Mx3(Inds),'-s','Color','k','MarkerEdgeColor','r','MarkerFaceColor','k','MarkerSize',MSize) 
%         end
%     end
end

% Set figure position
% if PlotMargins
%     set(gcf,'Position',[50+175*(k-1) -100+50*(k-1) 700 700])
% else
    set(gcf,'Position',[50+175*(k-1) 0+50*(k-1) 900 500])
% end

saveas(gcf,['Key Results/PlatoonPlots/' FName '.png'])

end
end

%end