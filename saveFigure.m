function [ output_args ] = saveFigure( handle, fileName )
% saveFigure 
%   Saves figure specified by `handle` as `fileName` in fullscreen
%   as to get around the stupid behavior.
    fileName = strcat('Figures\', fileName)
    set(handle,'PaperPositionMode','auto') %set paper pos for printing
    saveas(handle, fileName) % save figure
end