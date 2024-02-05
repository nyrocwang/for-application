function ShowData(data1,data2)
%SHOWDATA 显示点云数据
    x1 = data1(:, 1);
    y1 = data1(:, 2);
    z1 = data1(:, 3);

    x2 = data2(:, 1);
    y2 = data2(:, 2);
    z2 = data2(:, 3);
    
    figure();
    scatter3(x1, y1, z1,8 ,[1 0 0]);
    grid on;
    hold on;
    scatter3(x2, y2, z2,3, [0 0 1], 'filled');
    hold off;
end


