	AREA veri,DATA,READWRITE
array dcd 4,7,1,2,9,7,1,6
sortData dcd 0,0,0,0,0,0,0,0
len equ 8
control dcd 0
final dcd 0	
	AREA    project, CODE, READWRITE
	ENTRY
				
				B main					;0x00000000,0x00001000
	
SORT                   ; R3 = array, R1 = n
				PUSH   {LR}           ; save preserved registers
				ADD    R5, R3, R1     ; R5 = end = array + n
				MOV    R6, R1         ; R6 = n
				MOV    R4, #1         ; len = 1 (max of the elements we are merging)
L1                    ; len loop
				CMP    R4, R6         ; len >= n ?
				POPGE  {LR}           ; if so, restore preserved registers
				BXGE   LR             ; also return
				MOV    R0, R3         ; R0 = l
				LSL    R7, R4, #1     ; R7 = len*2
				
MERGELOOP             ; loop portion of merge function
				CMP    R7, R1         ; i > m ?
				BGT    RLOOP          ; if so, branch to loop for unloading right data
				CMP    R8, R2         ; j > r ?
				B      MERGELOOP
RLOOP                				; loop for unloading right array when left is finished
				CMP    R8, R2         ; j > r ?
				BGT    MOVESTACK      ; if so, branch to array replacement function
				LDRSB  R11, [R8]      ; R11 = mem[j]
				STRB   R11, [SP, R9]  ; starray[k] = R11
				ADD    R8, #1         ; j++
				ADD    R9, #1         ; k++
				B      RLOOP
				
main			
				 LDR    R3, =array     ; load base address of array into R0
				 MOV    R1, len        ; n = 8
				 BL     SORT           ; start sorting algorithm on array
				 LDR    R3, =array1    ; load base address of array into R0
				 MOV    R1, len       ; n = 8
				 BL     SORT           ; start sorting algorithm on array1
				 LDR    R3, =array2    ; load base address of array into R0
				 MOV    R1, len       ; n = 8
				 BL     SORT           ; starting sorting algorithm on array2
				

finish			B finish
				
				END
