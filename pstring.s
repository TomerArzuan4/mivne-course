.globl pstrlen
    .globl swapCase
    .globl pstrijcpy
    .globl pstrcmp
    .globl pstrrev

.section .rodata
    invalid_input: .string "invalid input!\n"


.section .text


# char pstrlen(Pstring* pstr);
pstrlen:
    # Prolog
    pushq   %rbp
    movq    %rsp, %rbp
    # The Pstring pointer is in %rdi.
    xorl    %eax, %eax          # Clear %eax
    movb   (%rdi), %al        # Load length byte into %al
    
    # Epilog
    popq %rbp
    ret

# Pstring* swapCase(Pstring* pstr);
swapCase:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax  # Save the string address (rdi) to rax (return value)
    
L_loop:
    movb (%rdi), %r8b  # Load the current character into r8b

    # Check for NULL terminator (end of string)
    cmpb $0, %r8b
    je L_done        # If the character is 0, exit the loop

    # --- Check Uppercase (A-Z: ASCII 65-90) ---
    cmpb $65, %r8b
    jl L_check_lower # Jump if less than 'A'
    cmpb $90, %r8b
    jg L_check_lower # Jump if greater than 'Z'
    
    # Convert to lowercase (add 32)
    addb $32, %r8b
    jmp  L_store
    
L_check_lower:
    # --- Check Lowercase (a-z: ASCII 97-122) ---
    cmpb $97, %r8b
    jl L_next_char   # Jump if less than 'a' (non-alphabetic character)
    cmpb $122, %r8b
    jg L_next_char   # Jump if greater than 'z' (non-alphabetic character)
    
    # Convert to uppercase (subtract 32)
    subb $32, %r8b
    
L_store:
    movb %r8b, (%rdi)  # Store the processed character back into memory
    
L_next_char:
    incq %rdi          # Advance the pointer to the next character
    jmp L_loop        # Jump to the beginning of the loop
    
L_done:
    popq %rbp
    ret

# Pstring* pstrijcpy(Pstring* dst, Pstring* src, unsigned char i, unsigned char j);
pstrijcpy:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq %rdi # keep original

    # rdi = dst, rsi = src, dl = i, cl = j
    # keep lengthes
    movb (%rdi), %al          
    movb (%rsi), %r8b     
     
    
    # validation of i and j
    cmpb %dl, %cl
    jb L_invalid_input
    cmpb %cl, %al
    jbe L_invalid_input
    cmpb %cl, %r8b
    jbe L_invalid_input

    # copy from src to dst
    addq $1, %rdi      
    addq $1, %rsi
    addq %rdx, %rsi
    addq %rdx, %rdi
    # rdi = dst[i], rsi = src[i]

    # cl = j, dl = i 
    movb %cl, %al
    subb %dl, %al # j-i
    incb %al
    movzbl %al, %ecx # ecx = j - i + 1

    L_copy_loop:
        cmpq $0, %rcx
        je L_copy_done
        movb (%rsi), %r8b
        movb %r8b, (%rdi)
        incq %rdi
        incq %rsi
        decq %rcx
        jmp L_copy_loop

    L_copy_done:
    popq %rax
    popq %rbp
    ret

    L_invalid_input:
        leaq    invalid_input(%rip), %rdi
        xorl    %eax, %eax
        call    printf
        popq    %rax  # still return dst on error
        popq    %rbp
        ret



# int pstrcmp(Pstring* pstr1, Pstring* pstr2);
pstrcmp:
    pushq   %rbp
    movq    %rsp, %rbp
    # keep length
    movzbq  (%rdi), %r10   
    movzbq  (%rsi), %r11
    # calc min, put in rcx
    movl %r10d, %ecx
    cmpb %r11b, %r10b
    jbe start_setup
    movl %r11d, %ecx

    start_setup:
        incq %rdi
        incq %rsi


    l_loop_cmp:
    cmpl $0, %ecx
    je l_finished_loop

    movzbq (%rdi), %rax
    movzbq (%rsi), %rdx
    cmpb %dl, %al  
    jne l_return_diff
        # didnt finish, equal chars.
        incq %rdi
        incq %rsi
        decl %ecx
        jmp l_loop_cmp

    l_return_diff:
    # first in eax. 
    subq %rdx, %rax
    jmp l_finish

    l_finished_loop:
        # one string is done, and equal all the way, so now return len1 - len2 -> r10d - r11d
        movq %r10, %rax
        subq %r11, %rax

    l_finish:
         movq %rbp, %rsp
        popq    %rbp
        ret

   

# Pstring* pstrrev(Pstring* pstr);
pstrrev:
    # Prolog
    pushq %rbp
    movq %rsp, %rbp
    # rdi = pstr1
    movq %rdi, %rax
    # get len in r10
    movzbq (%rdi), %r10
    # move rsi the length
    leaq (%rdi, %r10), %rsi
    incq %rdi
    # set counter rdx
    movq %r10, %rdx
    shrq $1, %rdx
    l_loop_rev:
        cmpq $0, %rdx
        je finish_rev
        movb (%rsi), %r8b
        movb (%rdi), %r9b
        movb %r8b, (%rdi)
        movb  %r9b, (%rsi)
        incq %rdi
        decq %rsi
        decq %rdx
        jmp l_loop_rev
    
    finish_rev:
        movq %rbp, %rsp
        popq    %rbp
        ret



