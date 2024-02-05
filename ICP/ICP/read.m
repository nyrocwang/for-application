P=load("project.txt");
% ShowData(P,P);
avg_h = mean(P(:,2));
[maxP,max_index]=max(P,[],1);
[minP,min_index]=min(P,[],1);
max_h=maxP(2);
min_h=minP(2);
[m,n]=size(P);
color = zeros(m,3);
for i=1:m
   if(P(i,2)>avg_h)
       color(i,1)=(P(i,2)-avg_h)/(max_h-avg_h);
   else 
       color(i,2)=(avg_h-P(i,2))/(avg_h-min_h);
   end
end
for i=1:m
    scatter(P(i,1),P(i,3),15,color(i,:),'filled');
    hold on;
end
