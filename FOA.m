function [xf,yf,CR] = FOA(x,y,maxgen)
%% 网络参数
L = 50;                  % 区域边长
n = 35;                  % 节点个数
rs = 5;                  % 感知半径
data = 0.5;              % 离散粒度
%% FOA参数
sizepop = 20;          % 种群规模
s = 0.3;               % 步长

%% 随机初始化果蝇群体位置
X_axis = x;
Y_axis = y;

%% 个体和速度最大和最小值
for i = 1:sizepop
    % 随机位置
    X(i, :) = X_axis + 2*s*rand(1, n)-s;
    Y(i, :) = Y_axis + 2*s*rand(1, n)-s;
    % 味道浓度函数(覆盖率)
    Smell(i) = computeCover(X(i, :), Y(i, :), L, rs, data);
end
% 找出此果蝇群体中味道浓度最高的果蝇(求极大值)
[bestSmell, bestindex]=max(Smell);
% 最佳气味浓度、果蝇位置、适应度最优位置
X_axis = X(bestindex, :);
Y_axis = Y(bestindex, :);
Smellbest = bestSmell;

%% 果蝇迭代寻优
for gen = 1:maxgen
    % 粒子位置和速度更新
    for i = 1:sizepop
        X(i, :) = X_axis + 2*s*rand(1, n)-s;
        Y(i, :) = Y_axis + 2*s*rand(1, n)-s;
        % 边界处理
        X(i, :) = max(X(i, :), 0);
        X(i, :) = min(X(i, :), L);
        Y(i, :) = max(Y(i, :), 0);
        Y(i, :) = min(Y(i, :), L);
        % 计算覆盖率
        Smell(i) = computeCover(X(i, :), Y(i, :), L, rs, data);
    end
    % 根据气味浓度值寻找极值
    [bestSmell, bestindex]=max(Smell);
    
    % 保留最佳值位置
    if bestSmell > Smellbest
        X_axis = X(bestindex, :);
        Y_axis = Y(bestindex, :);
        Smellbest = bestSmell;
    end
    % 每代最优Smell值记录到yy数组中，并记录最优迭代坐标
    yy(gen) = Smellbest;
    Xbest(gen, :) = X_axis;
    Ybest(gen, :) = Y_axis;
    % 显示迭代信息
    
end

xf = Xbest(end, :);
yf = Ybest(end, :);
CR = yy;


end