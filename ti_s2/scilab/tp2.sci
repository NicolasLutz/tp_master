//Fourier

function f=Four_apply(filename)
    img=imread(filename);
    f=double(img);
    ImLog=log(1+abs(fftshift(fft2(f))));
    maxImLog=max(ImLog);
    f=ImLog/maxImLog;
endfunction

function Four_bois()
    img=Four_apply("some_file.jpg");
    imwrite(uint8(f*255),"some_file_fourier.png");
endfunction

//Prewitt & Sobel

//Question 1:
//L'application des filtres approxime la dérivée première car :
//pour h1, variation importante entre valeurs des pixels 
//à gauche dans la fenêtre et à droite dans la fenêtre =>
//dérivée de la direction horizontale à pente élevée, et valeur après application
//du filtre sur le pixel non nulle (positive ou négative); on approxime ainsi la
//dérivée horizontale localement.
//cependant le filtre h1 ne détecte pas les variations verticales,
//et peu les variations diagonales.

//Question 2:
//c donne la pondération de la variation des valeurs des pixels, purement
//horizontalement dans le cas de h1 et purement verticalement dans le cas
//de h2. Plus la valeur de c est élevée, plus les fortes variations de valeur
//sont détectées, mais moins les variations sur les autres directions sont
//prises en compte.

//Question 3:
//Le bruit peut créer de brusques variations locales des valeurs des pixels,
//"affolant" ainsi le filtre qui renvoie une image elle-même bruitée.

function f=PS_toNorm2(i1h1, i1h2)
    img_size=size(i1h1);
    img_i=img_size(1);
    img_j=img_size(2);
    for i=1:img_i
        for j=1:img_j
            f(i,j)=round(sqrt(i1h1(i,j)^2+ i1h2(i,j)^ 2));
        end;
    end;
endfunction

function f=PS_prewitt(filename)
    img=imread(filename);
    c=1;
    h1=[1 0 -1; c 0 -c; 1 0 -1];
    h2=[-1 -c -1; 0 0 0; 1 c 1];
    f=double(img)/255.0;
    i1h1=imconv(f, h1);
    imwrite(uint8(i1h1*255),"prewittH1.png");
    i1h2=imconv(f, h2);
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
    i1h1=imconv(f, h1);
    imwrite(uint8(i1h1*255),"sobelH1.png");
    i1h2=imconv(f, h2);
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

//Lissage

//filtre carres impairs
function f=Li_filter(img, filter_size)
    f=img;
    img_size=size(img);
    img_i=img_size(1);
    img_j=img_size(2);
    
    size_div2=int(filter_size/2);
    
    for i=1:img_i
        for j=1:img_j
            
            q_sum=0.0;
            q_number=0;
            q_moy=0.0;
            //compute sum for the given window, then mean
            for hi=-size_div2:size_div2
                for hj=-size_div2:size_div2
                    ihi=i+hi;
                    jhj=j+hj;
                    if(ihi<=img_i & ihi>=1 & jhj<=img_j & jhj>=1) then
                        q=img(ihi, jhj);
                        q_sum=q_sum+q;
                        q_number=q_number+1;
                    end;
                end;
            end;
            q_moy=q_sum/q_number;
            f(i,j)=q_moy;
        end;
    end;
endfunction

function f=Li_lissage(filename, filter_size)
    img=imread(filename);
    img=double(img)/255.0;
    f=Li_filter(img, filter_size)
endfunction

function Li_objets_3()
    img=Li_lissage("images/grey/objets.jpg", 3);
    imwrite(uint8(img*255),"objets_lissage_3.png");
endfunction

function Li_objets_9()
    img=Li_lissage("images/grey/objets.jpg", 9);
    imwrite(uint8(img*255),"objets_lissage_9.png");
endfunction

function Li_all()
    Li_objets_3();
    Li_objets_9();
endfunction

//Kramer & Bruckner

//filtre carres impairs
function f=KB_filter(img, filter_size)
    f=img;
    img_size=size(img);
    img_i=img_size(1);
    img_j=img_size(2);
    
    size_div2=int(filter_size/2);
    
    for i=1:img_i
        for j=1:img_j
            
            q_min=1.0;
            q_max=0.0;
            q_moy=0.0;
            //compute maximum and minimum for the given window
            for hi=-size_div2:size_div2
                for hj=-size_div2:size_div2
                    clamped_ihi=max(1,min(i+hi, img_i));
                    clamped_jhj=max(1,min(j+hj, img_j));
                    q=img(clamped_ihi, clamped_jhj);
                    q_max=max(q_max, q);
                    q_min=min(q_min, q);
                end;
            end;
            q_moy=(q_max+q_min)/2;
            p=img(i,j);
            if(p>=q_moy) then
                f(i,j)=q_max;
            else
                f(i,j)=q_min;
            end;
        end;
    end;
endfunction

function f=KB_kramer_bruckner(filename, filter_size)
    img=imread(filename);
    img=double(img)/255.0;
    f=KB_filter(img, filter_size)
endfunction

function KB_bois_3()
    img=KB_kramer_bruckner("images/grey/bois.jpg", 3);
    imwrite(uint8(img*255),"kb_bois_3.png");
endfunction

function KB_objets_3()
    img=KB_kramer_bruckner("objets_lissage_3.png", 3);
    imwrite(uint8(img*255),"kb_objets_3.png");
endfunction

function KB_objets_7()
    img=KB_kramer_bruckner("objets_lissage_3.png", 7);
    imwrite(uint8(img*255),"kb_objets_7.png");
endfunction

function KB_objets_11()
    img=KB_kramer_bruckner("objets_lissage_3.png", 7);
    imwrite(uint8(img*255),"kb_objets_11.png");
endfunction

function KB_all()
    KB_bois_3();
    KB_objets_3();
    KB_objets_7();
    KB_objets_11();
endfunction
