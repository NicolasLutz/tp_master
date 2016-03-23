function f=histogramme(img, classes)
    truncClass=1;
    if classes>255 then truncClass=255;
    else if classes<1 then truncClass=1;
            else truncClass=classes;
        end
    end
    f=zeros(1,truncClass);
    img_size=size(img);
    img_x=img_size(1);
    img_y=img_size(2);
    for i=1:
        index=floor(double(i*truncClass)/256)+1;
        f(index)=f(index)+1;
    end
endfunction
