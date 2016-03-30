function f=fouriervisu(img)
    f=double(img);
    ImLog=log(1+abs(fftshift(fft2(f))));
    maxImLog=max(ImLog);
    f=ImLog/maxImLog
    imshow(f);
endfunction

function f=fouriervisu_color(img)
    f=double(img);
    f=f(:,:,1);
    ImLog=log(1+abs(fftshift(fft2(f))));
    maxImLog=max(ImLog);
    f=ImLog/maxImLog
    imshow(f);
endfunction

function f=filtre_tp(fft)
    f=fft;
    maxFft=max(fft);
    img_size=size(fft);
    img_i=img_size(1);
    img_j=img_size(2);
    size_2_i=img_size(1)/2;
    size_2_j=img_size(2)/2;
    maxR=sqrt((size_2_i)^2 + (size_2_j)^2);
    for i=1:img_i
        for j=1:img_j
            r=sqrt((i-size_2_i)^2+(j-size_2_j)^2);
            f(i,j)=maxFft-(r/maxR)*maxFft;
        end;//calculer histogramme en FONCTION DE R, puis moyenne des pixels à r
    end;
    imshow(f);
endfunction
