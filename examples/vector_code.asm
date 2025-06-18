.model tiny

.data

    n dw 8
    i dw 0
    a dw 7,11,4,9,2,6,7,8
    sum dw 0
    position dw 1     
    x dw 0
    y dw 0
    
    buffer  db 6 dup ('$')  ; Buffer to store up to 5 digits + the '$' terminator
                            ; '6 dup ($)' reserves 6 bytes and initializes with '$'.
                            ; This is for numbers up to 65535 (5 digits). 
                            
    jump_line   db 0Dh, 0Ah, '$'
    end_message db 'Thanks for you use the program!$'

.code
.startup

 mov di,i; di<-i 
 mov ax,n 
 mov bx,2
 mul bx
 mov y,ax 
 mov bx,0
 ciclo: mov ax,a[di]; ax<-a[di]
          mov x,di
          ;add bx,ax  
          
          jmp printing
          continue1:
          
          mov di,x
          add di,2; di<-di++
          cmp di,y
          jb ciclo; si di<n ir a ciclo
           
          mov ah, 09h
              lea dx, jump_line
              int 21h
   
              mov ah, 09h
              lea dx, end_message
              int 21h 
               
                
              mov ah, 4Ch
              int 21h
               
 ;mov sum,bx     
 
 
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
             jmp continue1    
 
 
 




