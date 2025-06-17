.model tiny

.data   

    n dw 4; table dimention
    
    l dw 0;
    
    x dw 0;
    
    y dw 0;
    
    position dw 1
    
    buffer  db 6 dup ('$')  ; Buffer to store up to 5 digits + the '$' terminator
                            ; '6 dup ($)' reserves 6 bytes and initializes with '$'.
                            ; This is for numbers up to 65535 (5 digits). 
                            
    eco_message     db 'Press a key to continue' ;Wait for an entry to continue
    row_message  db 'Rows matrix printing:'   
    colum_message  db 'Column matrix printing:'
    zigzag_message  db 'Zigzag matrix printing:'
    jump_line   db 0Dh, 0Ah, '$'
    end_message db 'Thanks for you use the program!$' 
    
    ; table
    m dw 3,1,2,3,4,5,6,7
      dw 8,9,10,11,12,13,14,15
      dw 16,17,18,19,20,21,22,23 
      dw 24,25,26,27,28,29,30,31
      dw 32,33,34,35,36,37,38,39
      dw 40,41,42,43,44,45,46,47
      dw 48,49,50,51,52,53,54,55
      dw 56,57,58,59,60,61,62,63

.code
.startup
;----------------Moving and Printing Matrix by Rows----------------
;-------------------------SOFIA MORENO-----------------------------

    mov ax,n; ax <- n
    sub ax,1; ax <- n-1
    mov l,ax; l <- n-1
    mov ax,0; ax <- 0 
    mov bx,0; bx <- 0
    mov di,0; di <- 0
    
    while: mov ax,m[bx][di]; ax <- m[bx][di]
           mov x,bx;
           mov y,di;
           jmp printing;
           continue1: mov bx,x;
                      mov di,y;
                      cmp di,l;
                      je if; if di == n go to if
                        inc di; di <- di + 1
                        jmp else;
                        if: inc bx; bx <- bx + 1
                            mov di,0; di <- 0    
                            
                            mov ah, 09h
                            lea dx, jump_line
                            int 21h     
                            
                        else: cmp bx, n;
                              jb while; if bx<l go to while
                              
;----------------Movement and Printing of Matrix by Columns----------------
;------------------------------GRECIA APELLIDO-----------------------------
    continue2:mov position,2
              mov ah, 09h
              lea dx, jump_line
              int 21h
   
              mov ah, 09h
              lea dx, end_message
              int 21h 
               
                
              mov ah, 4Ch
              int 21h 







;----------------Zigzag Matrix Movement and Printing----------------------
;------------------------------MANUEL ANTIAS------------------------------
    continue3:mov position,3
              mov ah, 09h
              lea dx, jump_line
              int 21h
   
              mov ah, 09h
              lea dx, end_message
              int 21h 
               
                
              mov ah, 4Ch
              int 21h



;----------------------------Code of Printing-----------------------------

    ;---------Separating of the digit-------- 
    
    
    
            
    printing:mov cx, 0                   ; Inicializar el contador de digitos a 0.
             mov bx, 10                  ; El divisor es 10 (para base decimal).
    
             separation_cycle:mov dx,0       ;Mantenemos dx limpio.
                              div bx     ;ax/bx.
                                ;ax=Cociente (ax/10).
                                ;ax=Resto (ax%10), este es el digito. 
                            
                              push dx    ;Empuja el digito a la pila del sistema.
                                ;La pila (LIFO) nos ayuda a recuperar numeros en el orden correcto.
                            
                              inc cx     ;cx<-cx+1.
                                ;Esto nos dice cuantos POPs se tendran que hacer.
                            
                              cmp ax,0   ; Comparar el cociente (ax) con 0.        
                     
                              jne separation_cycle   ;Si ax!=0, significa que aun hay digitos por procesar
                                                     ;y volvemos al ciclo de separacion.

             ;---Inicio de la conversion a ASCII y almacenamiento------------------------------------------       

             
    
             lea di,buffer               ;Carga la direccion (offset) de `buffer` en DI.
                                         ;DI sera nuestro puntero para escribir en el `buffer`.
                                
             ascci_cycle:pop dx          ;Saca un digito de la pila (LIFO).
    
                         add dl,'0'      ;Convierte el numero a su caracter ASCII.
                                         ;'0' es 30h. Si DL tiene 5, se convierte a 35h (ASCII '5').
                                         ;Se usa DL porque el dígito está en la parte baja de DX.
                                
                         mov [di], dl    ;Mover el carácter ASCII resultante al buffer en la posicion apuntada. 
                                         ;por DI.
                                
                         inc di          ;Incrementa DI para apuntar a la siguiente posicion libre en el buffer. 
                
                
             loop ascci_cycle            ;Decrementa CX en 1.Si CX no es cero, salta a la etiqueta `print_loop`. 
 

             mov byte ptr [di], ' '       ;Coloca un espacio en blanco ' ' al final de la cadena en el buffer.
                                          ;`byte ptr` es un "override" para indicar que estamos escribiendo un byte,
                                          ;ya que [di] por si solo podria ser ambiguo para el ensamblador.

             ;---Inicio de la impresion------------------------------------------------------------------------

             mov ah, 09h                  ;Carga la funcion de imprimir string (interrupcion 21h,subfuncion 09h).
             lea dx, buffer               ;carga la direccion (offset) de la cadena (el buffer) en DX.
                                          ;DS ya apunta al segmento de datos en el modelo TINY.

             int 21h
             cmp position,2               
             je  continue2 
             cmp position,3
             je  continue3
             jmp continue1    
;----------------------------End of program-----------------------------     

    ;mov ah, 09h
    ;lea dx, jump_line
    ;int 21h
   
    ;mov ah, 09h
    ;lea dx, end_message
    ;int 21h 
   
    
    ;mov ah, 4Ch
    ;int 21h