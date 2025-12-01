clc; close all; clear;
x = 0:19; y = x;                       % set up grid
v = zeros(20);
v(9, 10) = 4; v(10, 10) = 4;
v(9, 9) = 4; v(9, 10) = 4;             % constants
v_next = v;
figure;
for n = 1:500
    for k = 2:19
        for j = 2:19
            v_next(k, j) = 0.25 * (v(k + 1, j) ...
                + v(k - 1, j) + v(k, j + 1) + v(k, j - 1));
        end
    end
    v_next(11, 10) = 4; v_next(11, 11) = 4;
    v_next(10, 10) = 4; v_next(10, 11) = 4;
    v = v_next;
    surf(y, x, v);
    pause(0.01);
end