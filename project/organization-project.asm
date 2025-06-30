.model tiny 
; CATEDRA: ORGANIZACION DEL COMPUTADOR
; PROFESOR: OMAR HERNANDEZ

; ANTIAS, MANUEL CI.31.108.866
; MORENO, SOFIA  CI.31.448.315
; LOPEZ , GRECIA CI.30.908.067

.data   

    n dw 4; table dimention
    
    l dw 0;
    
    l2 dw 0;
    
    l3 dw 0;
    
    x dw 0;
    
    y dw 0;
    
    cant dw 0;
    
    direction dw 0;
    
    max dw 16;
    
    
    buffer  db 6 dup ('$')  ; Buffer to store up to 5 digits + the '$' terminator
                            ; '6 dup ($)' reserves 6 bytes and initializes with '$'.
                            ; This is for numbers up to 65535 (5 digits). 
                            
    press_message     db 'Press a key to continue$' ;Wait for an entry to continue
    
    row_message  db 'Rows matrix printing:$'  
                                                 
    colum_message  db 'Column matrix printing:$' 
    
    zigzag_message  db 'Zigzag matrix printing:$'  
    
    jump_line   db 0Dh, 0Ah, '$' 
    
    beep        db 07h,'$'                   
    
    end_message db 'Thanks for you use the program!$' 
    
    ; table
    m dw 6,12,15,1,0,0,0,0
      dw 5,13,16,2,0,0,0,0
      dw 7,14,17,3,0,0,0,0
      dw 5,15,18,4,0,0,0,0
      dw 0,0,0,0,0,0,0,0
      dw 0,0,0,0,0,0,0,0
      dw 0,0,0,0,0,0,0,0
      dw 0,0,0,0,0,0,0,0       
      
      

.code
.startup
;----------------Finding limits of movement----------------------           
    
    ;with this instructions we find the limit of the columns 
    ;in bits according to the dimention of the matrix
    mov ax,n; ax <- n
    mov bx,2; cx <- 2 
    mul bx; ax <- n*2
    mov l2, ax; l2 <- n*2
    dec l2; l2 <- l2-1
    dec l2; l2 <- l2-1
    
    ;with this instructions we find the limit of the rows 
    ;in bits according to the dimention of the matrix
    mov bx,max;
    mov ax,n;
    mul bx;
    mov l,ax; l <- n*16
    
;----------------Moving and Printing Matrix by Rows--------------
;-------------------------SOFIA MORENO---------------------------
    
    mov ah, 09h          ;Load the function to print characters.
    lea dx, beep         ;we active a beep sound in the system.
    int 21h              ;Call DOS interrupt to print the string.
    
    mov ah, 09h          
    lea dx, row_message
    int 21h              
      
    mov ah, 09h
    lea dx, jump_line
    int 21h
    
    mov ah, 09h
    lea dx, jump_line
    int 21h
    
    ;reinicializacion
    mov ax,0; ax <- 0 
    mov bx,0; bx <- 0
    mov di,0; di <- 0
    
    while: mov ax,m[bx][di]; ax <- m[bx][di]
           mov x,bx; Save current position
           mov y,di;  
           
           call printing;
           
           mov bx,x; Restore position
           mov di,y;
           cmp di,l2;
           je if; if di == l2 go to if
           inc di; di <- di + 1
           inc di; di <- di + 1
           jmp else;
           if: add bx,max;
           mov di,0; di <- 0    
                            
           mov ah, 09h
           lea dx, jump_line
           int 21h
                            
           else: cmp bx, l;
                 jb while; if bx<l go to while
  
           call delay
                              
;----------------Movement and Printing of Matrix by Columns------
;------------------------------GRECIA LOPEZ-------------------
    mov ah, 09h
    lea dx, beep
    int 21h 
                  
    mov ah, 09h
    lea dx, jump_line
    int 21h

    mov ah, 09h
    lea dx, colum_message
    int 21h  

    mov ah, 09h
    lea dx, jump_line
    int 21h

    mov ah, 09h
    lea dx, jump_line
    int 21h

    ; Initialize column counter
    mov di, 0              ; Start with column 0

    whileC:
        mov bx, 0          ; Start with row 0
    
        whileF:
            mov ax, m[bx][di]  ; ax <- m[bx][di]
            mov x,bx           ; Save current position
            mov y,di
            call printing      
        
            mov bx,x           ; Restore position
            mov di,y
            add bx, max        ; bx <- bx + 16 Move to the next row
            cmp bx, l          ; Check if it is the end of the column
            jb whileF          ; 

        ; Continue if I do not finish the column
        mov ah, 09h
        lea dx, jump_line
        int 21h
    
        inc di                 ; Move to the next column
        inc di                 ; 
        cmp di, l2             ; Check if it is the end of the array
        jbe whileC             ; Continue if I don't finish

       call delay






           

;----------------Zigzag Matrix Movement and Printing----------------------------
;------------------------------SOFIA MORENO & MANUEL ANTIAS---------------------
    mov ah, 09h
    lea dx, beep
    int 21h  
     
    mov ah, 09h
    lea dx, jump_line
    int 21h
              
    mov ah, 09h
    lea dx, zigzag_message
    int 21h  
      
    mov ah, 09h
    lea dx, jump_line
    int 21h
            
    mov ah, 09h
    lea dx, jump_line
    int 21h
    
    mov ax,n;
    mul n;
    mov l3,ax;number of elements to be printed
    mov ax,l;
    sub ax,max; lower limit of the matrix
    mov l,ax;
    
    ;reinicialization
    mov ax,0; ax <- 0 
    mov bx,0; bx <- 0
    mov di,0; di <- 0
    mov x,0;
    mov y,0;
    mov direction,1;
    
    whileZigZag: mov ax,m[bx][di]; ax <- m[bx][di]
                 mov x,bx; Save current position
                 mov y,di;  
                   
                 call printing;
                 
                 inc cant; we increased the amount of printed values
                 
                 mov bx,x; Restore position
                 mov di,y;
                 
                 ;comparing the address to know which block to go to
                 cmp direction,0;
                 je ifZigZag;
                 
                 ;Comparisons to determine whether to enter leftBottom or change1
                 cmp di,0;
                 je leftBotton;
                 cmp bx,l;
                 je leftBotton;
                 jmp change1;
                 
                 leftBotton:mov ah, 09h
                            lea dx, jump_line
                            int 21h
                            
                            mov direction,0; change of direction
                            
                            ;comparison to know if we should go down by adding 16 bits to bx 
                            ;or if we should go to the right by adding 2 bits to di
                            cmp bx,l;
                            jb left;
                            inc di;
                            inc di;
                            jmp endZigZag;
                            left: add bx,max;
                            jmp endZigZag;
                            
                 ;With this block we make the diagonal movement downwards
                 change1: add bx,max;
                          dec di;
                          dec di;
                          jmp endZigZag;
                  
                 
                 ifZigZag: ;Comparisons to determine whether to enter rightTop or change2
                           cmp bx,0;
                           je rightTop;
                           cmp di,l2;
                           je rightTop;
                           jmp change2;
                         
                           rightTop:mov ah, 09h
                                    lea dx, jump_line
                                    int 21h
                                  
                                    mov direction, 1; change of direction
                                    
                                    ;comparison to know if we should go down by adding 16 bits 
                                    ;to bx or if we should go to the right by adding 2 bits to di
                                    cmp di,l2;
                                    je  bottom;
                                    cmp bx,0;
                                    je right;
                                    bottom:add bx,max;
                                           jmp endZigZag;
                                    right: inc di;
                                           inc di;
                                    jmp endZigZag;
                           
                           ;With this block we make the diagonal movement upwards
                           change2: sub bx,max;
                                    inc di;
                                    inc di  
                 
                 ;comparison to know if the loop should continue or not          
                 endZigZag: mov ax,cant;
                            cmp ax,l3;
                            jb whileZigZag;


    call delay
    
    jmp end_program
    
;----------------------------Code of Printing--------------------------------------
;------------------------------MANUEL ANTIAS---------------------------------------

    ;--------------------Separating of the digit-----------------------------------
     
    
    
    
            
    printing:mov cx, 0                   
             mov bx, 10                  ; We will use bx to store the divisor.
    
             separation_cycle:mov dx,0   ;We keep dx clean.
                              div bx     ;ax has the quotient and dx the remainder.
                              push dx    ;We push the digit onto the system stack.
                              inc cx     ;cx<-cx+1.
                              cmp ax,0        
                              jne separation_cycle   ;If ax!=0, return to the cycle.
                  

    ;-------------Start of conversion to ASCII and storage------------------------------------------------------       

             
    
             lea di,buffer               ;Loads the address (offset) of `buffer` into DI.
                                
             ascci_cycle:pop dx          ;We take a digit from the stack (LIFO).
                         add dl,30h      ;We convert the number to its ASCII character.
                         mov [di], dl    ;We move the resulting ASCII character to the buffer at position di. 
                         inc di          ;Incrementa DI para apuntar a la siguiente posicion libre en el buffer. 
                
                
             loop ascci_cycle            ;Decrement cx by 1. If cx!=0, return to `print_loop`. 
 

             mov byte ptr [di], ' '      ;We put a blank space ' ' at the end of the string in the buffer.

    ;-----------------------------Start of printing-------------------------------------------------------------

             mov ah, 09h                  
             lea dx, buffer              ;loads the address (offset) of the string (the buffer) into dx.
                                          

             int 21h
             ret                         ;We put a return in the code to call it in different instances
             
;----------------------------Delay of program----------------------------- -------------------------------------
;------------------------------MANUEL ANTIAS--------------------------------------------------------------------

       
    ;Here we define a delay of 1,000,000 microseconds (1 second) (0F4240h in hexadecimal)
       
    delay:mov cx, 0Fh                    ;We save the high part of the time in hexadecimal.
          mov dx, 4240h                  ;We save the lower part of the time in hexadecimal.
          mov ah, 86h                    ;We load service number 86h into AH, which is the BIOS delay function.
          int 15h                        ;This is the instruction that triggers the BIOS function call.
                             
          ret                            ;We put a return in the code to call it in different instances           

   
;----------------------------End of program---------------------------------------------------------------------
     
    end_program:mov ah, 09h
                lea dx, jump_line
                int 21h
                            
                mov ah, 09h
                lea dx, beep
                int 21h            
                            
                mov ah, 09h
                lea dx, press_message    ;Message waiting for keyboard input
                int 21h
                                         
                mov ah, 01h              ;Function to read a character from the keyboard
                int 21h         
               
                mov ah, 09h
                lea dx, jump_line
                int 21h   
               
                mov ah, 09h
                lea dx, jump_line
                int 21h 
                
                mov ah, 09h
                lea dx, beep
                int 21h 
   
                mov ah, 09h
                lea dx, end_message
                int 21h 
   
    
                mov ah, 4Ch              ;completion of the program
                int 21h