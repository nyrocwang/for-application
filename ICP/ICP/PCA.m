clear all;
%读取待匹配点云数据P
% % P=load("data.asc");
P=load("project-25.txt");
P=P(:,1:3);
Rt=[1 0 0 
    0 0.866 0.5
    0 -0.5 0.866];
tt=[1 1.5 0.3]';
Pt=P';
PP=zeros(3,25)
for i = 1:25        
    PP(:,i) = Rt*Pt(:,i)+tt;
end

P=PP;

Pc = pointCloud(P');
Pc = pcdownsample(Pc,'gridAverage',40);



Pm(:,1)= double(Pc.Location(:,1));
Pm(:,2)= double(Pc.Location(:,2));
Pm(:,3)= double(Pc.Location(:,3));

clear P;

P=Pm';


%读取目标点云数据Q
% Q=load("model.asc");
Q=load("no-noise.txt");
Q=Q(:,1:3);

Qc = pointCloud(Q);
% pcshowpair(Pc,Qc);
Q=Q';


ShowData(P',Q');


[R1,T1] = pca_function(P,Q);

% 
% R1=[1 -2.0874e-05 1.0061e-05
%     1.3047e-05 0.8660 -0.5
%     -1.9150e-07 0.5 0.8660];
% t1=[0.00162133985768520;-0.000266786715094725;0.000861305119506994]';

aliData=(R1*P+repmat(T1,1,size(P,2)))';
refData=Q';
ShowData(aliData,refData);
title('粗配准点云对比图');xlabel('x轴');ylabel('y轴');zlabel('z轴');



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

function plot_3d( data_source, color )
    x1=data_source(:,1);
    y1=data_source(:,2);
    z1=data_source(:,3);
    scatter3(x1,y1,z1,'filled',color);
    xlabel('x轴');
    ylabel('y轴');
    zlabel('z轴');
end

