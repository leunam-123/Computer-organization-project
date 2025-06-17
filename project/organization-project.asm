.model tiny

.data   

    n dw 4; table dimention
    
    l dw 0;
    
    x dw 0;
    
    y dw 0;
    
     
    
    ; table
    m dw 0,1,2,3,4,5,6,7
      dw 8,9,10,11,12,13,14,15
      dw 16,17,18,19,20,21,22,23 
      dw 24,25,26,27,28,29,30,31
      dw 32,33,34,35,36,37,38,39
      dw 40,41,42,43,44,45,46,47
      dw 48,49,50,51,52,53,54,55
      dw 56,57,58,59,60,61,62,63

.code
.startup

    mov ax,n; ax <- n
    sub ax,1; ax <- n-1
    mov l,ax; l <- n-1
    mov ax,0; ax <- 0 
    mov bx,0; bx <- 0
    mov di,0; di <- 0
    
    while: mov ax,m[bx][di]; ax <- m[bx][di]
           mov x,bx;
           mov y,di;
           ;jmp print;
           continue1: mov bx,x;
                      mov di,y;
                      cmp di,l;
                      je if; if di == n go to if
                        inc di; di <- di + 1
                        jmp else;
                        if: inc bx; bx <- bx + 1
                            mov di,0; di <- 0
                            ;salto de linea
                        else: cmp bx, l;
                              jb while; if bx<l go to while