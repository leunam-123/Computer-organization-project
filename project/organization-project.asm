.model tiny

.data   

    n dw 4; table dimention
    
    l dw 0;
    
    l2 dw 0;
    
    x dw 0;
    
    y dw 0;
    
    max dw 16;
    
    position dw 1
    
    buffer  db 6 dup ('$')  ; Buffer to store up to 5 digits + the '$' terminator
                            ; '6 dup ($)' reserves 6 bytes and initializes with '$'.
                            ; This is for numbers up to 65535 (5 digits). 
                            
    press_message     db 'Press a key to continue$' ;Wait for an entry to continue
    
    row_message  db 'Rows matrix printing:$'  
                                                 
    colum_message  db 'Column matrix printing:$' 
    
    zigzag_message  db 'Zigzag matrix printing:$'  
    
    jump_line   db 0Dh, 0Ah, '$'                    
    
    end_message db 'Thanks for you use the program!$' 
    
    ; table
    m dw 0,1,2,3,0,0,0,0
      dw 4,5,6,7,0,0,0,0
      dw 8,9,10,11,0,0,0,0
      dw 12,13,14,15,0,0,0,0
      dw 0,0,0,0,0,0,0,0
      dw 0,0,0,0,0,0,0,0
      dw 0,0,0,0,0,0,0,0
      dw 0,0,0,0,0,0,0,0       
      
      

.code
.startup
;----------------Finding limits of movement----------------------
      
    mov ah, 09h          ;Load the function to print characters
    lea dx, row_message
    int 21h              ;Call DOS interrupt to print the string.
      
    mov ah, 09h
    lea dx, jump_line
    int 21h
    
    mov ah, 09h
    lea dx, jump_line
    int 21h       
    
    ;with this instructions we find the limit of the columns 
    ;in bits according to the dimention of the matrix
    mov ax,n; ax <- n
    mov bx,2; cx <- 2 
    mul bx; ax <- n*2
    mov l2, ax; l2 <- 16-n*2
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

    ;reinicializacion
    mov ax,0; ax <- 0 
    mov bx,0; bx <- 0
    mov di,0; di <- 0
    
    while: mov ax,m[bx][di]; ax <- m[bx][di]
           mov x,bx;
           mov y,di;  
           
           call printing; 
           
           mov bx,x;
           mov di,y;
           cmp di,l2;
           je if; if di < l go to if
           inc di; di <- di + 1
           inc di; di <- di + 1
           jmp else;
           if: add bx,max;
           mov di,0; di <- 0    
                            
           mov ah, 09h
           lea dx, jump_line
           int 21h
                            
           else: cmp bx, l;
                 jb while; if bx<l2 go to while
  
           call delay
                              
;----------------Movement and Printing of Matrix by Columns------
;------------------------------GRECIA LOPEZ-------------------
           
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
                      
   
            





           jmp end_program

;----------------Zigzag Matrix Movement and Printing-------------
;------------------------------MANUEL ANTIAS---------------------
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
   



;----------------------------Code of Printing--------------------------------------

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
                         add dl,'0'      ;We convert the number to its ASCII character.
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
       
    ;Here we define a delay of 1,000,000 microseconds (1 second) (0F4240h in hexadecimal)
       
    delay:mov cx, 0Fh                    ;We save the high part of the time in hexadecimal.
          mov dx, 4240h                  ;We save the lower part of the time in hexadecimal.
          mov ah, 86h                    ;This instruction expects a time value in microseconds.
          int 15h                        ;This is the instruction that triggers the BIOS function call.
          
          mov dx,0
          mov ax,0                       
          ret                            ;We put a return in the code to call it in different instances           

   
;----------------------------End of program---------------------------------------------------------------------
     
    end_program:mov ah, 09h
                lea dx, jump_line
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
                lea dx, end_message
                int 21h 
   
    
                mov ah, 4Ch              ;completion of the program
                int 21h