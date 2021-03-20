        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
       

      ;; Exercício 6
main    
      MOVS R8, #14    ; valor qualquer usado como exemplo
      MOVS R9, #3     ; valor qualquer usado como exemplo
      BL Mul8b        ; sub-rotina da multiplicação
      BL Div8b        ; sub-rotina da divisão
      B fim
      
;;Multiplicação       
Mul8b:
      MOVS R0, R8     ; R0 := R8 para poder utilizar o "CBZ", que só pode ser usado nos registradores de 0 a 7. E também para não mexer no valor de entrada, podendo usá-lo na divisão
      MOVS R1, R9     ; R1 := R9 para poder utilizar o "CBZ", que só pode ser usado nos registradores de 0 a 7. E também para não mexer no valor de entrada, podendo usá-lo na divisão
loopm
      ADD R2, R2, R0  ; R2 := R2 + R0 // R2 é o produto
      SUB R1, R1, #1  ; R1 := R1 - 1 // R1 mostra quantas vezes eu devo somar o R2
      CBZ R1, jumpm   ; R1 := 0 ? if yes: jumpd, if not: next line
      B loopm
jumpm
      MOVS R10, R2    ; R10 := R2 // R10 recebe o valor do produto: R8*R9
      BX LR           ; return
            
;;Divisão      
Div8b:
      MOVS R3, R9     ; R3 := R9
      MOVS R4, R8     ; R4 := R8 para poder utilizar o "CBZ", que só pode ser usado nos registradores de 0 a 7.
loopd      
      SUBS R4, R4, R3 ; R4 := R4 - R3 // R4:resto da divisão
      ADDS R5, R5, #1 ; R5 := R5 + 1 R5: quocionte
      CBZ R4, jumpd   ; R0 := 0 ? if yes: jumpd, if not: next line
      SUBS R6, R4, R3 ; R6 := R4 - R3
      BMI jumpd       ;IF(R4<R3) jumpd
      B loopd
jumpd
      MOVS R11, R5    ; R11 := R5 // R11 recebe o valor do quociente
      MOVS R12, R4    ; R12 := R4 // R12 recebe o valor do resto da divisão 
      BX LR           ; return

fim

      ;; Exercício 7 início
;;main
      ;;MOV R0, #0x11     ; R0 := 0x11
      ;;MOV R1, #0x22     ; R1 := 0x22
      ;;MOV R2, #0x33     ; R2 := 0x33
      ;;PUSH {R0, R1, R2} ; Coloca na pilha nessa ordem: R2, R1, R0
      ;;POP {R3, R4, R5}  ; Tira da pilha nessa ordem: R0, R1, R2
      ;;EOR R0, R0, #0xF0 ; ou exclusivo
      ;;EOR R1, R1, #0x0F
      ;;EOR R2, R2, #0xFF
      ;;B main      

      ;; Exercício 7 trocando PUSH com POP
;;main
      ;;MOV R0, #0x11
      ;;MOV R1, #0x22
      ;;MOV R2, #0x33
      ;;POP {R0, R1, R2} ;dá erro
      ;;PUSH {R3, R4, R5}
      ;;EOR R0, R0, #0xF0 ; ou exclusivo
      ;;EOR R1, R1, #0x0F
      ;;EOR R2, R2, #0xFF
      ;;B main 
       
             
        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
