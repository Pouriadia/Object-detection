clc; clear; close all

% This program takes about 1 min to run, be patient :)

image_dataset_path = "Images\";
dest_path = "Recunstructed_Images\";
dataset = dir("Images\");

positive_templates = cell(1, 9);
negative_templates = cell(1, 9);
for i = 1:9
    positive_templates{1, i} = imread("Templates\" + num2str(i) + "_1.png");
    negative_templates{1, i} = imread("Templates\" + num2str(i) + "_2.png");
end

my_sum = zeros(1, 100);
original_sum = zeros(1, 100);
for index = 1:numel(dataset)
    if dataset(index).isdir == 0
        name = dataset(index).name;
        t = strfind(name, '_');
        x = t(1);
        y = t(2);
        z = strfind(name, '.');
        original_sum(str2num(name(x + 1:y - 1))) = str2double(name(y + 1:z - 1));
    end
end

for index = 1:numel(dataset)
    if dataset(index).isdir == 0
        image = imread(image_dataset_path + dataset(index).name);
        new_image = image;
        noisy_gray = rgb2gray(image);
        noiseless_gray = pepper_removal(noisy_gray, 1);
        row = size(noiseless_gray, 1);
        column = size(noiseless_gray, 2);
        sum = 0;
        for i = 1:row
            for j = 1:column
                if noiseless_gray(i, j) ~= 255
                    [min_x, min_y, max_x, max_y] = visit(noiseless_gray, [i j]);
                    template = noiseless_gray(min_x:max_x, min_y:max_y);
                    noiseless_gray(min_x:max_x, min_y:max_y) = 255;
                    max_psnr = 0;
                    number = 1;
                    if(min(min(template)) < 40)
                        for k = 1:9
                            temp = imresize(template, [size(negative_templates{k}, 1) size(negative_templates{k}, 2)]);
                            temp_psnr = psnr(temp, negative_templates{k});
                            if temp_psnr > max_psnr
                                number = k;
                                max_psnr = temp_psnr;
                            end
                        end
                        sum = sum - number;
                    else
                        for k = 1:9
                            temp = imresize(template, [size(positive_templates{k}, 1) size(positive_templates{k}, 2)]);
                            temp_psnr = psnr(temp, positive_templates{k});
                            if temp_psnr > max_psnr
                                number = k;
                                max_psnr = temp_psnr;
                            end
                        end
                        sum = sum + number;
                    end
                end
            end
        end
        name = dataset(index).name;
        t = strfind(name, '_');
        x = t(1);
        y = t(2);
        my_sum(str2num(name(x + 1:y - 1))) = sum;
        R = new_image(:, :, 1);
        G = new_image(:, :, 2);
        B = new_image(:, :, 3);
        if abs(sum) ~= sum
            % write sign
            R(776:780, 20:50) = 0;
            B(776:780, 20:50) = 0;
        end
        rest = 70;
        if floor(abs(sum) / 10) ~= 0
            tmp = imresize(negative_templates{floor(abs(sum) / 10)}, 0.5);
            for g = 1:size(tmp, 1)
                for h = 1:size(tmp, 2)
                    if tmp(g, h) ~= 255
                        R(760 + g, rest + h) = 0;
                        B(760 + g, rest + h) = 0;
                    end
                end
            end
        end
        rest = rest + 30;
        if mod(abs(sum), 10) ~= 0
            tmp = imresize(negative_templates{mod(abs(sum), 10)}, 0.9);
            for g = 1:size(tmp, 1)
                for h = 1:size(tmp, 2)
                    if tmp(g, h) ~= 255
                        R(760 + g, rest + h) = 0;
                        B(760 + g, rest + h) = 0;
                    end
                end
            end
        else
            R(780:784, rest:rest + 4) = 0;
            B(780:784, rest:rest + 4) = 0;
        end
        recunstructed_image = cat(3, R, G, B);
        imwrite(recunstructed_image, dest_path + '_' + name(x + 1:y - 1) + '.png')
    end
end

precision = 0;
for i = 1:numel(original_sum)
    if original_sum(i) == my_sum(i)
        precision = precision + 1;
    end
end

disp(["Precision =" precision])



