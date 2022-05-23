clc; clear; close all;
%% 初始条件设置
 L = 50; % 区域边长 
 n = 35; % 节点数量
 rs = 5; % 感知距离
 data = 0.5; % 离散粒度
%%%% 随机部署节点
X = L * rand(1,n);
Y = L * rand(1,n);
%% 基本虚拟力算法
disp("*********VFA start*********Please waitting......*******");
[x_VFA, y_VFA, CoverageRate_VFA] = VFA(X, Y);
disp("*********VFA end***************************************"); disp(" ");

%% 基于步长指数递减策略的虚拟力算法
disp("*********IVFA_FOA start*****Please waitting......******");
[x_IVFA, y_IVFA, CoverageRate_IVFA] = IVFA(X, Y);
disp("*********IVFA_FOA end**********************************"); disp(" ");

%% 基于步长指数递减策略的虚拟力果蝇融合算法
disp("*********IVFA_FOA start*****Please waitting......******");
[x_IVFA_FOA, y_IVFA_FOA, CoverageRate_IVFA_FOA] = IVFA_FOA(X, Y);
disp("*********IVFA_FOA end**********************************"); disp(" ");

%% 果蝇算法
disp("*********FOA start*********Please waitting......*******");
[x_FOA, y_FOA, CoverageRate_FOA] = FOA(X, Y, 500);
disp("*********FOA end***************************************"); disp(" ");

%% 覆盖率结果
initialCoverageRate = computeCover(X, Y, L, rs, data); % 初始覆盖率
VFACoverageRate = computeCover(x_VFA, y_VFA, L, rs, data); % 虚拟力最终覆盖率
IVFACoverageRate = computeCover(x_IVFA, y_IVFA, L, rs, data); % 改进步长覆盖率
FOACoverageRate = computeCover(x_FOA, y_FOA, L, rs, data); % 果蝇最终覆盖率
IVFA_FOACoverageRate = computeCover(x_IVFA_FOA, y_IVFA_FOA, L, rs, data); % 改进最终覆盖率
disp("The initial coverage rate is: " + num2str(initialCoverageRate));
disp("The VFA coverage rate is: " + num2str(VFACoverageRate));
disp("The IVFA coverage rate is: " + num2str(IVFACoverageRate));
disp("The FOA coverage rate is: " + num2str(FOACoverageRate));
disp("The IVFA-FOA coverage rate is: " + num2str(IVFA_FOACoverageRate));

%% 绘图
 figure (1); %初始覆盖图
for i = 1:n
    axis([0 L 0 L]);            % 限制坐标范围
    sita = 0:pi/100:2*pi;   % 角度[0, 2*pi]
    hold on;
    p2 = plot(X(i)+rs*cos(sita), Y(i)+rs*sin(sita), 'b', 'linewidth',1.5);
end
plot(X,Y,'k*', 'linewidth',1); title("初始覆盖图"); grid on;
xlabel("X/m");ylabel("Y/m");set(gca,'XTick',[0:5:50]);
axis([0 L 0 L]);

figure (2); %VFA最终覆盖图
for i = 1:n
    axis([0 L 0 L]);            % 限制坐标范围
    sita = 0:pi/100:2*pi;   % 角度[0, 2*pi]
    hold on;
    p2 = plot(x_VFA(i)+rs*cos(sita), y_VFA(i)+rs*sin(sita), 'g', 'linewidth',1.5);
end
plot(x_VFA,y_VFA,'k*', 'linewidth',1);title("VFA"); grid on;
xlabel("X/m");ylabel("Y/m");set(gca,'XTick',[0:5:50]);
axis([0 L 0 L]);

figure (3); %IVFA最终覆盖图
for i = 1:n
    axis([0 L 0 L]);            % 限制坐标范围
    sita = 0:pi/100:2*pi;   % 角度[0, 2*pi]
    hold on;
    p2 = plot(x_IVFA(i)+rs*cos(sita), y_IVFA(i)+rs*sin(sita), 'c', 'linewidth',1.5);
end
plot(x_IVFA,y_IVFA,'k*', 'linewidth',1);title("IVFA"); grid on;
xlabel("X/m");ylabel("Y/m");set(gca,'XTick',[0:5:50]);
axis([0 L 0 L]);

figure (4); %FOA最终覆盖图
for i = 1:n
    axis([0 L 0 L]);            % 限制坐标范围
    sita = 0:pi/100:2*pi;   % 角度[0, 2*pi]
    hold on;
    p2 = plot(x_FOA(i)+rs*cos(sita), y_FOA(i)+rs*sin(sita), 'm', 'linewidth',1.5);
end
plot(x_FOA,y_FOA,'k*', 'linewidth',1);title("FOA"); grid on;
xlabel("X/m");ylabel("Y/m");set(gca,'XTick',[0:5:50]);
axis([0 L 0 L]);

figure (5); %改进最终覆盖图
for i = 1:n
    axis([0 L 0 L]);            % 限制坐标范围
    sita = 0:pi/100:2*pi;   % 角度[0, 2*pi]
    hold on; 
    p2 = plot(x_IVFA_FOA(i)+rs*cos(sita), y_IVFA_FOA(i)+rs*sin(sita), 'r', 'linewidth',1.5);
end
plot(x_IVFA_FOA,y_IVFA_FOA,'k*', 'linewidth',1);title("FOA-IVFA"); grid on;
xlabel("X/m");ylabel("Y/m");set(gca,'XTick',[0:5:50]);
axis([0 L 0 L]);

figure (6)
hold on;
iter = 500;
plot(1:iter,CoverageRate_VFA(1:iter),'g', 'linewidth',1.5);
plot(1:iter,CoverageRate_IVFA(1:iter),'c', 'linewidth',1.5);
plot(1:iter,CoverageRate_FOA(1:iter),'m', 'linewidth',1.5);
plot(1:iter,CoverageRate_IVFA_FOA(1:iter),'r', 'linewidth',1.5);
xlabel("迭代次数");ylabel("覆盖率");%set(gca,'XTick',[1:10:500]);
legend("VFA","IVFA","FOA","FOA-IVFA",'FontSize',15,'location','best');
legend boxoff;


%% 不同迭代次数比较
CR = [CoverageRate_VFA(200:100:500); CoverageRate_IVFA(200:100:500);
    CoverageRate_FOA(200:100:500); CoverageRate_IVFA_FOA(200:100:500)]';
bar(CR','DisplayName','CR');
axis([1 4 0.7 0.95]);








