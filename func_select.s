.global run_func
.type run_func, @function
.section .rodata
    .invalid_prompt: .string "invalid option!\n"
    .len_output: .string "first pstring length: %d, second pstring length: %d\n"
    .swap_output: .string "length: %d, string: %s\n"

.text
    run_func:
        pushq %rbp
        movq %rsp, %rbp
        pushq %r12 # string 1
        pushq %r13 # string 2
        movq %rsi, %r12
        movq %rdx, %r13


        cmpl $31, %edi
        je .pstrln_func
    

        cmpl $33, %edi
        je .swapCase_func

        cmpl $34, %edi
        je .pstrijcpy_func

        cmpl $41, %edi
        je .pstrcmp_func

        cmpl $42, %edi
        je .pstrrev_func

        .deafult:
            leaq    .invalid_prompt(%rip), %rdi
            xorl %eax, %eax
            call printf
            jmp .func_end
        # both strings in r12, r13
        .pstrln_func:
            # first 
            movq %r12, %rdi
            call pstrlen
            movl %eax, %r8d
            # second
            movq %r13, %rdi
            call pstrlen
            movl %eax, %r9d
            # print
            # load prompt
            leaq .len_output(%rip), %rdi
            # load first
            movl %r8d, %esi
            # load second
            movl %r9d, %edx

            xorl %eax, %eax
            call printf
            jmp .func_end


        .swapCase_func:
            # first string and print
            movq %r12, %rdi
            call swapCase
            leaq .swap_output(%rip), %rdi # rax holds the swapped string
            xorl %esi, %esi
            movb (%rax), %sil # sil (rsi) holds the length
            leaq 1(%rax), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf
            # second
            movq %r13, %rdi
            call swapCase
            leaq .swap_output(%rip), %rdi # rax holds the swapped string
            xorl %esi, %esi
            movb (%rax), %sil # sil (rsi) holds the length
            leaq 1(%rax), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf








            jmp     .func_end

        .pstrijcpy_func:
            # Implementation for pstrijcpy (Choice 34)
            jmp     .func_end

        .pstrcmp_func:
            # Implementation for pstrcmp (Choice 41)
            jmp     .func_end

        .pstrrev_func:
            # Implementation for pstrrev (Choice 42)
            jmp     .func_end
                

        .func_end:
            pop %r13
            pop %r12
            popq %rbp
            ret













