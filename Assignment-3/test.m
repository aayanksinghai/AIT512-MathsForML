%Aayank Singhai

clear all;
close all;
clc;

domain = linspace(-4, 4, 1000);
varList = [1, 0.25, 1/9, 1/16];
numCurves = numel(varList);

pdfData = zeros(numCurves, numel(domain));

gaussianPDF = @(x_vec, v) (1./sqrt(2*pi*v)) .* exp(-(x_vec.^2)./(2*v));

integralAreas = zeros(numCurves, 1);
for i = 1:numCurves
    currentVar = varList(i);
    pdfData(i, :) = gaussianPDF(domain, currentVar);
    integralAreas(i) = trapz(domain, pdfData(i, :));
end

disp('--- Numerical Integration Check ---');
disp('Variance      | Area');
disp('---------------------------------');
for i = 1:numCurves
    fprintf('Var: %-7.4f | Area: %-7.6f\n', varList(i), integralAreas(i));
end

figure(1);
set(gcf, 'Color', 'w', 'Position', [100 100 900 450]);
colorMap = jet(numCurves);

hold on;
for i = 1:numCurves
    plot(domain, pdfData(i, :), 'LineWidth', 2, 'Color', colorMap(i,:));
end
hold off;

legendEntries = arrayfun(@(v) sprintf('\\sigma^2 = %.3f', v), varList, 'UniformOutput', false);
legend(legendEntries, 'Location', 'northeast');
xlabel('x');
ylabel('PDF f(x)');
title('Gaussian PDF Comparison as Variance Decreases');
grid on;
box on;
set(gca,'FontSize',12);

figure(2);
set(gcf, 'Color', 'w', 'Position', [200 200 700 450]);

animVarList = [linspace(1, 0.1, 15), 0.08, 0.05, 0.02, 0.01, 0.005];

for v = animVarList
    y_anim = gaussianPDF(domain, v);
    
    plot(domain, y_anim, 'LineWidth', 2.5, 'Color', 'r'); 
    
    ylim([0 max(pdfData(:))*1.1]); 
    xlim([domain(1) domain(end)]);
    
    title(sprintf('Approaching the Impulse: \\sigma^2 = %.4f', v), 'FontSize', 14);
    xlabel('x');
    ylabel('PDF f(x)');
    grid on;
    
    drawnow;
    pause(0.25);
end

figure(3);
set(gcf, 'Color', 'w', 'Position', [300 300 700 450]);

plot(domain, pdfData(1,:), 'LineWidth', 1.5, 'Color', [0.7 0.7 0.7]);
hold on;
for i = 2:numCurves
    plot(domain, pdfData(i,:), 'LineWidth', 2, 'Color', colorMap(i,:));
end
hold off;

xlim([-0.5 0.5]);
legend(legendEntries, 'Location', 'northeast');
xlabel('x');
ylabel('PDF f(x)');
title('Zoomed View: Spike Formation at x=0');
grid on;
box on;
set(gca,'FontSize',12);

figure(4);
set(gcf, 'Color', 'w', 'Position', [400 400 700 450]);

smallestVarIdx = numCurves;
y_smallest = pdfData(smallestVarIdx, :);

plot(domain, y_smallest, 'k', 'LineWidth', 1.5);
hold on;

fill(domain, y_smallest, [0.8 1 0.8], 'EdgeColor', 'none');

xlabel('x');
ylabel('PDF f(x)');
title(sprintf('Area for \\sigma^2 = %.3f is %.6f', ...
    varList(smallestVarIdx), integralAreas(smallestVarIdx)), 'FontSize', 12);
grid on;
set(gca,'FontSize',12);