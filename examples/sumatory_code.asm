
.MODEL TINY

.DATA
    n   dw  20
    i   dw  0            
    sum dw  0            
    
    buffer  db 6 dup ('$')  ; Buffer para almacenar hasta 5 digitos + el terminador '$'
                            ; '6 dup ($)' reserva 6 bytes e inicializa con '$'.
                            ; Esto es para numeros hasta 65535 (5 digitos).
                            
    result_message  db 'La sumatoria del numero dado es: $'
    eco_message     db 'Presione enter para finalizar'
    jump_line   db 0Dh, 0Ah, '$' ; Un solo salto de linea
    end_message db 'Gracias por usar el programa!$'

.CODE
.STARTUP ; Punto de entrada para programas .COM en modelo TINY      

    ;---------Calcular la Sumatoria de N---------------------------------------------------------- 
    
    mov ax,sum                  ;sum<-0.
    cycle:                 
           mov cx,i             ;cx<-i.
           add ax,i             ;ax<-ax+1.
           cmp cx,n             ;Compara i con n
           inc i                ;i<-i+1.
           jbe cycle            ;Salta a la etiqueta ciclo si i<=n.
    mov sum,ax                  ;Guarda en sum todas las sumas de n.      
                                                                   
    ;---------Separar el numero de Sum para poder imprimirlo--------------------------------------
              
    mov cx, 0                   ; Inicializar el contador de digitos a 0.
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

    ; Ahora, los digitos estan en la pila en orden inverso.Los sacamos de la misma, los convertimos 
    ; a ASCII y los guardamos en el buffer. De esta manera los tendremos ordenados nuevamente.
    
    lea di,buffer               ;Carga la direccion (offset) de `buffer` en DI.
                                ;DI sera nuestro puntero para escribir en el `buffer`.
                                
    ascci_cycle:pop dx          ;Saca un digito de la pila (LIFO).
    
                add dl,'0'      ;Convierte el numero a su caracter ASCII.
                                ;'0' es 30h. Si DL tiene 5, se convierte a 35h (ASCII '5').
                                ;Se usa DL porque el dígito está en la parte baja de DX.
                                
                mov [di], dl    ;Mover el carácter ASCII resultante al buffer en la posicion apuntada. 
                                ;por DI.
                                
                inc di          ;Incrementa DI para apuntar a la siguiente posicion libre en el buffer. 
                
                
   loop ascci_cycle             ;Decrementa CX en 1.Si CX no es cero, salta a la etiqueta `print_loop`. 
 

   mov byte ptr [di], '$'       ;Colcoa el terminador '$' al final de la cadena en el buffer.
                                ;`byte ptr` es un "override" para indicar que estamos escribiendo un byte,
                                ;ya que [di] por si solo podria ser ambiguo para el ensamblador.
                                
   ;---Inicio de la impresion------------------------------------------------------------------------
   
    ; 1. Imprimir "La sumatoria del numero dado es: "
    mov ah, 09h
    lea dx, result_message
    int 21h

    ; 2. Imprimir el numero (que ya esta en 'buffer')
    mov ah, 09h                  ;Carga la funcion de imprimir string (interrupcion 21h,subfuncion 09h).
    lea dx, buffer               ;carga la direccion (offset) de la cadena (el buffer) en DX.
                                 ;DS ya apunta al segmento de datos en el modelo TINY.

    int 21h                      ;Llamar a la interrupcion de DOS para que imprima la cadena.

    ; 3. Imprimir el primer salto de linea
    mov ah, 09h
    lea dx, jump_line
    int 21h

    ; 4. Imprimir el segundo salto de linea
    mov ah, 09h
    lea dx, jump_line
    int 21h

    
    ; 5. Imprimir "Presione enter para finalizar"
    mov ah, 09h
    lea dx, eco_message
    int 21h
    
    mov ah, 01h     ; Funcion para leer un caracter del teclado (con eco)
    int 21h         ; Llamar a la interrupcion de DOS. El programa se pausara aqui.
   
   
   ;---Inicio de la impresion------------------------------------------------------------------------
   
   ; 6. Imprimir "Gracias por usar el programa"
   
   mov ah, 09h
   lea dx, jump_line
   int 21h
   
   mov ah, 09h
   lea dx, end_message
   int 21h 
   
    
   mov ah, 4Ch
   int 21h                          