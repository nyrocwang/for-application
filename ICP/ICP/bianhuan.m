
clear;

data3=load('model.asc');
data2(:,1)=data3(:,1);
data2(:,2)=data3(:,2);
data2(:,3)=data3(:,3);
data2(:,4)=1;

R=[1 0 0 70;
    0 cos(pi/6) -sin(pi/6) 70;
    0 sin(pi/6) cos(pi/6) 20;
    0 0 0 1];
% R=[0.3408 0.4859 0.8049 100;
%     0.3976 -0.8503 0.3449 200;
%     0.8519 0.2024 -0.4829 300;
%     0 0 0 1];
data2=R*data2';
data2=data2';

data5(:,1)=data2(:,1);
data5(:,2)=data2(:,2);
data5(:,3)=data2(:,3);

figure();
plot3(data5(:,1), data5(:,2), data5(:,3), 'r.');
hold on;
plot3(data3(:,1), data3(:,2), data3(:,3), 'b.');
hold off;


fid = fopen('data.asc','w');
fprintf(fid,'%f,%f,%f\n',data5');
fclose(fid);
