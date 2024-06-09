function [result] = pepper_removal(image, iterations)
    kernel_size = 3;
    pad_bound = floor(kernel_size / 2);
    result = zeros(size(image, 1),size(image, 2), 'uint8');
    for k = 1:iterations
        padded_image = padarray(image, [pad_bound pad_bound], 0,"both");
        for i = (1 + pad_bound):(size(padded_image, 1) - pad_bound)
            for j = (1 + pad_bound):(size(padded_image, 2) - pad_bound)
                if padded_image(i, j) == 0
                    sub_array = padded_image(i - pad_bound:i + pad_bound, j - pad_bound:j + pad_bound);
                    sub_array = sub_array(sub_array ~= 0);                   
                    if size(sub_array, 1) == 0
                        value = 255;
                    else
                        value = median(sub_array);                             
                    end
                    result(i - pad_bound, j - pad_bound) = value;
                else
                    result(i - pad_bound, j - pad_bound) = padded_image(i, j);
                end
            end
        end
        image = result;
    end
end
