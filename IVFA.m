function [xI,yI,CR] = IVFA(X,Y)
%IFVA_FOA 基于步长指数递减策略的虚拟力果蝇融合算法
%   首先针对节点在虚拟力作用下的移动步长采用指数递减策略，其次利用果蝇寻优提高局部搜索能力
xI = X; yI = Y; 
L = 50; % 区域边长
n = 35; % 节点数量
rs = 5; % 感知距离
dTh = sqrt(3) * rs; %距离阈值
wa = 1; % 引力参数
wr = 1000; % 斥力参数
max_sensor = 1; %传感器节点移动的最大步长（在传感器节点作用下的最大步长）
min_sensor = 0.1; %传感器节点移动的最小步长（在传感器节点作用下的最小步长）
data = 0.5; % 离散粒度
tMax = 500; % 迭代次数
% initialCoverageRate = computeCover(X, Y, L, rs, data); % 初始覆盖率

for t = 1:tMax
    
    %%%% 计算每个节点受的虚拟力合力
    for i = 1:n
        %%%% 各个节点之间的虚拟力影响
        index = 1;% 对测试节点产生影响的节点数目，应该满足index = n - 1
        for j = 1:n
            if i ~= j
                d_sensor = sqrt((xI(j) - xI(i))^2 + (yI(j) - yI(i))^2);
                
                if d_sensor > dTh %引力
                    f_x(index) = wa * (xI(j) - xI(i)); % 每个节点的引力水平分力
                    f_y(index) = wa * (yI(j) - yI(i)); % 每个节点的引力垂直分力
                    % 每个节点的引力合力
                    index = index + 1;
                else
                    if d_sensor < dTh %斥力
                        f_x(index) = wr * (xI(i) - xI(j)); % 每个节点的斥力水平分力
                        f_y(index) = wr * (yI(i) - yI(j)); % 每个节点的斥力垂直分力
                        index = index + 1;
                    else
                        f_x(index) = 0; f_y(index) = 0;
                        index = index + 1;
                    end
                end
            end
        end
        
        F_x(i) = sum(f_x);
        F_y(i) = sum(f_y);
        %F_xy(i) = sqrt(F_x(i)^2 + F_y(i)^2); % 第i个节点受到其他所有节点虚拟力的合力
        F_xy(i) = sqrt(F_x(i)^2 + F_y(i)^2);
    end
    
    %%%% 计算合力
    for i = 1:n
        Force_x(i) = F_x(i) ;
        Force_y(i) = F_y(i) ;
        %Force_xy(i) = sqrt(Force_x(i)^2 + Force_y(i)^2);
        Force_xy(i) = F_xy(i) ;
    end
    
    %%%% 根据所受合力更新每个节点位置
    for i = 1:n
        %%%% 第i个节点位置更新
        %step(t) = max_sensor - (max_sensor - min_sensor) * (t / tMax);%自适应步长更新(NO)
        step(t) = min_sensor * power((max_sensor / min_sensor), (1 / (1 + (10 * t) / tMax))); % 指数策略递减
        xOld(i) = xI(i);
        yOld(i) = yI(i);
        xIVFANew(i) = xOld(i) + (Force_x(i) / Force_xy(i)) * step(t) * exp(-1 / Force_xy(i));
        yIVFANew(i) = yOld(i) + (Force_y(i) / Force_xy(i)) * step(t) * exp(-1 / Force_xy(i));
        %%%% 边界处理
        if xIVFANew(i) >= L || xIVFANew(i) <= 0
            xIVFANew(i) = L * rand();
        end
        if yIVFANew(i) >= L || yIVFANew(i) <= 0
            yIVFANew(i) = L * rand();
        end
    end
    
    
%     coverageRateI(t) = computeCover(xIVFANew, yIVFANew, L, rs, data); % 每次迭代假设位置更新后覆盖率
%     if t == 1 && coverageRateI(t) > initialCoverageRate
%         xI = xIVFANew; yI = yIVFANew;
%     else
%         coverageRateI(1) = initialCoverageRate;
%     end
%     
%     if t > 1 && coverageRateI(t) > coverageRateI(t - 1)
%         xI = xIVFANew; yI = yIVFANew; % 若效果优于上次迭代，则更新位置
%     end
    
    
     coverageRateImprove(t) = computeCover(xIVFANew, yIVFANew, L, rs, data); % 每次虚拟力和果蝇寻优后迭代覆盖率
%     if t == 1 && coverageRateImprove(t) > initialCoverageRate
%         xI = x_FOANew; yI = y_FOANew;
%     else
%         coverageRateImprove(1) = initialCoverageRate;
%     end
    
    if t > 1 && coverageRateImprove(t) > coverageRateImprove(t - 1) 
        xI = xIVFANew; yI = yIVFANew; % 若效果优于上次迭代，则更新位置
    end
    
    coverageRateImprove(t) = computeCover(xI, yI, L, rs, data);
    %CR(t) = computeCover(xI, yI, L, rs, data);
    
    
    disp(num2str(t) + ": " + num2str(coverageRateImprove(t)));
end


CR = coverageRateImprove;

end

