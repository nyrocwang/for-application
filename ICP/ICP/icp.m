
clear all;
% 读取源点云数据P
% P=load("data.asc");
P=load("project-25.asc")
P=P(:,1:3);

Px=P*100;

Rt=[1 0 0 
    0 0.866 0.5
    0 -0.5 0.866];
tt=[1 1.5 0.3]';
Pt=P';
PP=zeros(3,25);

for i = 1:25        
    PP(:,i) = Rt*Pt(:,i)+tt;
end
P=PP';
P=P*100;

P0=P;
% X=load("no-noise.txt");

%读取目标点云数据Q
% Q=load("model.asc");
Q=load("project.txt")
Q=Q(:,1:3);
Q=Q*100;

ShowData(Px,Q);
ShowData(P,Q);


[R1,T1] = pca_function(P',Q');
  
 P=(R1*P'+repmat(T1,1,size(P',2)))';

ShowData(P,Q);

difference=zeros(size(Q,1),3);   %创建记录坐标差值矩阵
mapPoint=zeros(size(P,1),3);    %创建与源点集对应的映射矩阵
distance=zeros(size(Q,1),1);    %创建记录所有距离的矩阵
n=size(P,1);

tic
j=0; 
d=100;
d_rec=zeros(1,2000);
while d>0.1
    j=j+1;
     fprintf("迭代次数：%d\n",j);
    %%
    %寻找点云数据P中点Pi的对应点Qi
    %使用欧式距离最近的点作为对应点
    for i=1:n
        difference=Q-P(i,:);       %坐标差值
        difference=difference.^2;
        distance=sum(difference,2);
        [~,minIndex]=min(distance);
        mapPoint(i,:)=Q(minIndex,:);    %保存对应点
    end
    %%
    %计算旋转矩阵R和平移矩阵t的最优解，使用svd方法
    centerP=mean(P);    %P点集的质心点
    centerMap=mean(mapPoint);      %对应点集的质心点
    tempP=P-centerP;        %进行去中心化
    tempMapPoint=mapPoint-centerMap;
    
    H=tempP'*tempMapPoint;  %得到H矩阵
    [U,~,V]=svd(H);
    R=V*U';
    %     T=(centerP-centerMap)';
    T=-R*centerP'+centerMap';   %利用质心点求解T参数
    %%
    %使用R和T来得到新的点集
    P=(R*P'+T)';       %使用转换参数得到新的点集P
    d=sum(sum((P-mapPoint).^2,2))/n;	%计算新的点集P到对应点的平均距离
    d_rec(j)=d;
    if j>2000
        break
    end
end
toc
ShowData(P,Q);

%%求解变换矩阵
mapPoint=P;
P=P0;
centerP=mean(P);    %P点集的质心点
centerMap=mean(mapPoint);      %对应点集的质心点
tempP=P-centerP;        %进行去中心化
tempMapPoint=mapPoint-centerMap;
H=tempP'*tempMapPoint;  %得到H矩阵
[U,~,V]=svd(H);
R=V*U';
%     T=(centerP-centerMap)';
T=-R*centerP'+centerMap';   %利用质心点求解T参数


%%理论变换矩阵




function [R,T] = pca_function(P,Q)
	point1=size(P,2);
	point2=size(Q,2);
	
	pcenter = mean(P,2);
	qcenter = mean(Q,2); 
	
	xx = P - repmat(pcenter,1,point1); 
	Mx =xx * xx';
	yy = Q - repmat(qcenter,1,point2);
    My = yy * yy';
	
	[Vx,Dx] = eig(Mx,'nobalance'); %Vx特征向量,Dx特征值
	[Vy,Dy] = eig(My,'nobalance');
	
	[~,index]=max(sum(xx.*xx));
	xm=xx(:,index);
	xm(3,1)=-abs(xm(3,1));
	p3 = Vx(:,3);
	if dot(xm,p3)<0
	    p3=-p3;
	end
	p2 = Vx(:,2);
	if dot(xm,p2)<0
	    p2=-p2;
	end
	p1=cross(p3,p2);
	
	[~,index]=max(sum(yy.*yy));
	ym=yy(:,index);
	ym(3,1)=-abs(ym(3,1));
	q3 = Vy(:,3);
	if dot(ym,q3)<0
	    q3=-q3;
	end
	q2 = Vy(:,2);
	if dot(ym,q2)<0
	    q2=-q2;
	end
	q1=cross(q3,q2);
	
	R = [q1,q2,q3]/[p1,p2,p3];
	xc2 = R*pcenter;
	T = (qcenter - xc2);
end
