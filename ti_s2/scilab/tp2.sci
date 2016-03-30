function f=get_img(img, i, j)
    img_size=size(img);
    img_i=img_size(1);
    img_j=img_size(2);
    if(i<1) then
        i=1;
    elseif(i>img_i) then
        i=img_i;
    end;
    if(j<1) then
        j=1;
    elseif(j>img_j) then
        j=img_j;
    end;
    f=img(i,j);
endfunction

function f=any_filter(img, h)
    img_size=size(img);
    img_i=img_size(1);
    img_j=img_size(2);
    
    h_size=size(h);
    h_i=h_size(1);
    h_j=h_size(2);
    
    for i=1:img_i
        for j=1:img_j
            f(i,j)=0;
            for hi=1:h_i
                for hj=1:h_j
                    f(i,j)=f(i,j)+get_img(img, i+hi-2, j+hj-2)*h(hi,hj);
                end;
            end;
        end;
    end;
endfunction

function f=PS_toNorm2(i1h1, i1h2)
    img_size=size(i1h1);
    img_i=img_size(1);
    img_j=img_size(2);
    for i=1:img_i
        for j=1:img_j
            f(i,j)=sqrt(i1h1(i,j)^2+ i1h2(i,j)^ 2);
        end;
    end;
endfunction

function f=PS_prewitt(filename)
    img=imread(filename);
    c=1;
    h1=[1 0 -1; c 0 -c; 1 0 -1];
    h2=[-1 -c -1; 0 0 0; 1 c 1];
    f=double(img)/255.0;
    i1h1=any_filter(f, h1);
    imwrite(uint8(i1h1*255),"prewittH1.png");
    i1h2=any_filter(f, h2);
    imwrite(uint8(i1h2*255),"prewittH2.png");
    f=PS_toNorm2(i1h1, i1h2);
    imwrite(uint8(f*255),"prewittN2H1H2.png");
endfunction

function f=PS_sobel(filename) //normaliser en fonction du gradiant
    img=imread(filename);
    c=2;
    h1=[1 0 -1; c 0 -c; 1 0 -1];
    h2=[-1 -c -1; 0 0 0; 1 c 1];
    f=double(img)/255.0;
    i1h1=any_filter(f, h1);
    imwrite(uint8(i1h1*255),"sobelH1.png");
    i1h2=any_filter(f, h2);
    imwrite(uint8(i1h2*255),"sobelH2.png");
    f=PS_toNorm2(i1h1, i1h2);
    imwrite(uint8(f*255),"sobelN2H1H2.png");
endfunction

function PS_full(filename)
    PS_prewitt(filename);
    PS_sobel(filename);
endfunction

function PS_bois()
    PS_full("images/grey/bois.jpg");
endfunction

function PS_lena()
    PS_full("images/grey/lena.jpg");
endfunction
