.globl pstrlen
    .globl swapCase
    .globl pstrijcpy
    .globl pstrcmp
    .globl pstrrev

.text


# char pstrlen(Pstring* pstr);
pstrlen:
    # Prolog
    pushq   %rbp
    movq    %rsp, %rbp
    .
    # The Pstring pointer is in %rdi.
    xorl    %eax, %eax          # Clear %eax
    movb   (%rdi), %al        # Load length byte into %al
    
    # Epilog
    popq %rbp
    ret

# Pstring* swapCase(Pstring* pstr);
swapCase:
    pushq   %rbp
    movq    %rsp, %rbp
    movq %rdi, %rax

    xorq %rcx, %rcx
    movb (%rdi), %cl

    cmpb $0, %cl
    je .finish_loop

    incq %rdi
    .L_loop:
        movb (%rdi), %r8b
            # check A-Z
            cmpb $65, %r8b
            jl .L_next_char
            cmpb $90, %r8b
            jg .L_check_lower
            addb $32, %r8b
            jmp .L_store
        .L_check_lower:
            cmpb $97, %r8b
            jl .L_next_char
            cmpb $122, %r8b
            jg .L_next_char
            subb $32, %r8b
        .L_store:
            movb %r8b, (%rdi)
        .L_next_char:
            incq %rdi
            loop .L_loop
        .L_done:
            popq %rbp
             ret





    # Return pstr (in %rdi) (Stub)
    movq    %rdi, %rax

    # Epilog
    popq    %rbp
    ret

# Pstring* pstrijcpy(Pstring* dst, Pstring* src, unsigned char i, unsigned char j);
pstrijcpy:
    # Prolog
    pushq   %rbp
    movq    %rsp, %rbp

    # Return dst (in %rdi) (Stub)
    movq    %rdi, %rax

    # Epilog
    popq    %rbp
    ret

# int pstrcmp(Pstring* pstr1, Pstring* pstr2);
pstrcmp:
    # Prolog
    pushq   %rbp
    movq    %rsp, %rbp

    # Return 0 (Stub)
    movl    $0, %eax

    # Epilog
    popq    %rbp
    ret

# Pstring* pstrrev(Pstring* pstr);
pstrrev:
    # Prolog
    pushq   %rbp
    movq    %rsp, %rbp

    # Return pstr (in %rdi) (Stub)
    movq    %rdi, %rax

    # Epilog
    popq    %rbp
    ret