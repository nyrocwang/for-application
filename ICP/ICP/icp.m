
clear all;
% ��ȡԴ��������P
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

%��ȡĿ���������Q
% Q=load("model.asc");
Q=load("project.txt")
Q=Q(:,1:3);
Q=Q*100;

ShowData(Px,Q);
ShowData(P,Q);


[R1,T1] = pca_function(P',Q');
  
 P=(R1*P'+repmat(T1,1,size(P',2)))';

ShowData(P,Q);

difference=zeros(size(Q,1),3);   %������¼�����ֵ����
mapPoint=zeros(size(P,1),3);    %������Դ�㼯��Ӧ��ӳ�����
distance=zeros(size(Q,1),1);    %������¼���о���ľ���
n=size(P,1);

tic
j=0; 
d=100;
d_rec=zeros(1,2000);
while d>0.1
    j=j+1;
     fprintf("����������%d\n",j);
    %%
    %Ѱ�ҵ�������P�е�Pi�Ķ�Ӧ��Qi
    %ʹ��ŷʽ��������ĵ���Ϊ��Ӧ��
    for i=1:n
        difference=Q-P(i,:);       %�����ֵ
        difference=difference.^2;
        distance=sum(difference,2);
        [~,minIndex]=min(distance);
        mapPoint(i,:)=Q(minIndex,:);    %�����Ӧ��
    end
    %%
    %������ת����R��ƽ�ƾ���t�����Ž⣬ʹ��svd����
    centerP=mean(P);    %P�㼯�����ĵ�
    centerMap=mean(mapPoint);      %��Ӧ�㼯�����ĵ�
    tempP=P-centerP;        %����ȥ���Ļ�
    tempMapPoint=mapPoint-centerMap;
    
    H=tempP'*tempMapPoint;  %�õ�H����
    [U,~,V]=svd(H);
    R=V*U';
    %     T=(centerP-centerMap)';
    T=-R*centerP'+centerMap';   %�������ĵ����T����
    %%
    %ʹ��R��T���õ��µĵ㼯
    P=(R*P'+T)';       %ʹ��ת�������õ��µĵ㼯P
    d=sum(sum((P-mapPoint).^2,2))/n;	%�����µĵ㼯P����Ӧ���ƽ������
    d_rec(j)=d;
    if j>2000
        break
    end
end
toc
ShowData(P,Q);

%%���任����
mapPoint=P;
P=P0;
centerP=mean(P);    %P�㼯�����ĵ�
centerMap=mean(mapPoint);      %��Ӧ�㼯�����ĵ�
tempP=P-centerP;        %����ȥ���Ļ�
tempMapPoint=mapPoint-centerMap;
H=tempP'*tempMapPoint;  %�õ�H����
[U,~,V]=svd(H);
R=V*U';
%     T=(centerP-centerMap)';
T=-R*centerP'+centerMap';   %�������ĵ����T����


%%���۱任����




function [R,T] = pca_function(P,Q)
	point1=size(P,2);
	point2=size(Q,2);
	
	pcenter = mean(P,2);
	qcenter = mean(Q,2); 
	
	xx = P - repmat(pcenter,1,point1); 
	Mx =xx * xx';
	yy = Q - repmat(qcenter,1,point2);
    My = yy * yy';
	
	[Vx,Dx] = eig(Mx,'nobalance'); %Vx��������,Dx����ֵ
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
