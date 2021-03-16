;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

    ORG RAMStart
; variable/data section
output_string DS.B 16
input_string FCC "ThIs Is A sTrInG. AnTher SenTenCE"
space        FCC  " "
period       FCC  "."
test_character FCC "a"
; need compare value for ASCII $61 ~'a'
; create to lower/ upper shift
;l_shift EQU #$20

string_length DS.B 1
test_count DS.B 1


; code section
            ORG   ROMStart



Entry:
_Startup:
    LDS #RAMEnd+1
    CLI
mainLoop:
    LDAA #0
    STAA test_count
    LDAA #16
    STAA string_length
    LDX #input_string
    LDY #output_string
innerLoop:
    LDAB 1,x+
    
    CMPB  space
    BEQ   skipUpdate
    
    CMPB  period
    BEQ   skipUpdate
    
    CMPB test_character
    ; compare test number with string i) lower case ii) upper case iii) first element
    ;BNE skipUpdate
    ; use BGE with test_character 'a' for greater than or equal to.
    BGE skipUpdate
    ADDB  #$20
    
    INC test_count
skipUpdate:
    STAB 0,y
    INY
    DECA
    BNE innerLoop
    BRA mainLoop     

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
