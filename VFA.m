function [x,y,CR] = VFA(X,Y)
%VFA 虚拟力算法部署
%   输入初始随机位置，输出经过基础虚拟力算法部署后的位置
x = X; y = Y; 
L = 50; % 区域边长
n = 35; % 节点数量
rs = 5; % 感知距离
dTh = sqrt(3) * rs; %距离阈值
wa = 1; % 引力参数
wr = 1000; % 斥力参数
%max_sensor = 1; %传感器节点移动的最大步长（在传感器节点作用下的最大步长）
%min_sensor = 0.1; %传感器节点移动的最小步长（在传感器节点作用下的最小步长）
data = 0.5; % 离散粒度
tMax = 500; % 迭代次数
%initialCoverageRate = computeCover(X, Y, L, rs, data); % 初始覆盖率
for t = 1:tMax
    %%%% 计算每个节点受的虚拟力合力
    for i = 1:n
        %%%% 各个节点之间的虚拟力影响
        index = 1;% 对测试节点产生影响的节点数目，应该满足index = n - 1
        for j = 1:n
            if i ~= j
                d_sensor = sqrt((x(j) - x(i))^2 + (y(j) - y(i))^2);
                
                if d_sensor > dTh %引力
                    f_x(index) = wa * (x(j) - x(i)); % 每个节点的引力水平分力
                    f_y(index) = wa * (y(j) - y(i)); % 每个节点的引力垂直分力
                    % 每个节点的引力合力
                    index = index + 1;
                else
                    if d_sensor < dTh %斥力
                        f_x(index) = wr * (x(i) - x(j)); % 每个节点的斥力水平分力
                        f_y(index) = wr * (y(i) - y(j)); % 每个节点的斥力垂直分力
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
        xOld(i) = x(i);
        yOld(i) = y(i);
        step = 1 ;
        xNew(i) = xOld(i) + (Force_x(i) / Force_xy(i)) * step * exp(-1 / Force_xy(i));
        yNew(i) = yOld(i) + (Force_y(i) / Force_xy(i)) * step * exp(-1 / Force_xy(i));
        %%%% 边界处理
        if xNew(i) >= L || xNew(i) <= 0
            xNew(i) = L * rand();
        end
        if yNew(i) >= L || yNew(i) <= 0
            yNew(i) = L * rand();
        end
        
    end
    
     coverageRate(t) = computeCover(xNew, yNew, L, rs, data); % 每次迭代假设位置更新后覆盖率
%     if t == 1 && coverageRate(t) > initialCoverageRate
%         x = xNew; y = yNew;
%     else
%         coverageRate(1) = initialCoverageRate;
%     end
    if t > 1 && coverageRate(t) > coverageRate(t - 1)
        x = xNew; y = yNew; % 若效果优于上次迭代，则更新位置
    end
    coverageRate(t) = computeCover(x, y, L, rs, data); % 每次迭代覆盖率
    
    %disp(num2str(t) + ": " + num2str(coverageRate(t)));
end
CR = coverageRate; % 返回每次迭代的覆盖率

end

