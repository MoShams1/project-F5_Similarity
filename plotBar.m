% To plot a bar plot with errorbards indicating 95% confidence intervals
% calculate the
function plotBar(A)
% A: cell or mat (repetition x category), comma separated!

if isnumeric(A)
    for icol = 1:size(A,2)
        A_cell{icol} = A(:,icol);
    end
    A = A_cell;
end

ncat = numel(A); % number of categories
bw = .3; % bar width
lw = 1; % line width

for i = 1:ncat
    fill([i-bw,i+bw,i+bw,i-bw],[0 0 nanmean(A{i}) nanmean(A{i})],[.7 .7 .7],'edgecolor','none');
    hold on    
end

for i = 1:ncat
    count = sum(~isnan(A{i}));
    s(i) = nanstd(A{i},1) / (count.^.5) * 1.96;
    m(i) = nanmean(A{i});

    line([i i],[nanmean(A{i})-s(i) nanmean(A{i})+s(i)],'linewidth',lw,'color','k')
end

line([0 ncat+1],[0 0],'color','k')

xlim([0 ncat+1])

if max(s)==0
    ylim([min(m)-(max(m)-min(m))/2 max(m)+(max(m)-min(m))/2])
else
    ylim([min(m)-3*max(s) max(m)+3*max(s)])
end
set(gca,'xtick',1:ncat)
cleanplot