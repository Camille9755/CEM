%=============================================
% draw surface current distribution of target
% author: ZhangQiang
% date: 2017-05-19 20:51:00
%=============================================
% example:
%       scfilepath = 'C;\xx\xx\xx\current.sc'
%=============================================
scfilepath = input('Input the Path of "current.sc" File: ', 's');

[x, y, z, c] = scread(scfilepath);

% set figure size and background
set(gcf, 'outerposition', get(0, 'screensize'));
set(gcf, 'color', 'white');

% get model size
x_min = min(min(x));
y_min = min(min(y));
z_min = min(min(z));
x_max = max(max(x));
y_max = max(max(y));
z_max = max(max(z));

% set x/y/z axis range
min_pos = [x_min y_min z_min];
max_pos = [x_max y_max z_max];
ext = 0.1 * max(max_pos - min_pos);
min_pos = min_pos - ext;
max_pos = max_pos + ext;

set(gca, 'XLim', [min_pos(1) max_pos(1)]);
set(gca, 'YLim', [min_pos(2) max_pos(2)]);
set(gca, 'ZLim', [min_pos(3) max_pos(3)]);
% set x/y/z axis color
set(gca, 'XColor', 'blue');
set(gca, 'YColor', 'green');
set(gca, 'ZColor', 'red');
% set title
title('\fontsize{28}SURFACE ELECTRIC CURRENT DISTRIBUTION');

patch(x, y, z, c)

shading interp
axis equal
% set colorbar
h = colorbar;
set(get(h, 'Title'), 'string', 'A/m');
set(h, 'FontSize', 12);
% set viewpoint
view([145 40])

function [x, y, z, c] = scread(filename)
%  Read surface current result of EMSuit
%  x: [3, triangle_num], x coordinate of corresponding vertex
%  y: [3, triangle_num], y coordinate of corresponding vertex
%  z: [3, triangle_num], z coordinate of corresponding vertex
%  c: [3, triangle_num], current magnitude of corresponding vertex
fid = fopen(filename, 'r');
if(fid == -1)
    error('fail opening file')
end

tri_num = fscanf(fid, '%*s %d\n', 1);
fprintf('Triangle Facet: %d\n', tri_num);
fgetl(fid);

x = zeros(3, tri_num);
y = zeros(3, tri_num);
z = zeros(3, tri_num);
c = zeros(3, tri_num);

h = waitbar(0, 'Please wait...');
total = floor(tri_num / 20);
for i = 1:tri_num
    fscanf(fid, '%d', 1);
    
    aux = fscanf(fid, '%f', [1 13]);
    x(:,i) = [aux(1); aux(4); aux(7)];
    y(:,i) = [aux(2); aux(5); aux(8)];
    z(:,i) = [aux(3); aux(6); aux(9)];
    c(:,i) = [aux(10); aux(11); aux(12)];
    
    if(mod(i, total) == 0)
        waitbar(i/tri_num, h);
    end
end

fclose(fid);
close(h);
disp('Done!');
end