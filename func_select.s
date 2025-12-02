.global run_func
.type run_func, @function
.section .rodata
    invalid_prompt: .string "invalid option!\n"
    pstrlen_output: .string "first pstring length: %d, second pstring length: %d\n"
    len_output: .string "length: %d, string: %s\n"
    scanf_format: .string "%hhu %hhu"
    invalid_input: .string "invalid input!\n"
    low_cmp: .string "First string is smaller\n"
    equal_cmp: .string "Strings are equal\n"
    high_cmp: .string "First string is larger\n"

.text
    run_func:
        pushq %rbp 
        movq %rsp, %rbp
        pushq %r12 # string 1
        pushq %r13 # string 2
        movq %rsi, %r12
        movq %rdx, %r13


        cmpl $31, %edi
        je pstrln_func
    

        cmpl $33, %edi
        je swapCase_func

        cmpl $34, %edi
        je pstrijcpy_func

        cmpl $41, %edi
        je pstrcmp_func

        cmpl $42, %edi
        je pstrrev_func

        deafult:
            leaq invalid_prompt(%rip), %rdi
            xorl %eax, %eax
            call printf
            jmp func_end
        # both strings in r12, r13
        pstrln_func:
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
            leaq pstrlen_output(%rip), %rdi
            # load first
            movl %r8d, %esi
            # load second
            movl %r9d, %edx

            xorl %eax, %eax
            call printf
            jmp func_end


        swapCase_func:
            # first string and print
            movq %r12, %rdi
            call swapCase
            leaq len_output(%rip), %rdi # rax holds the swapped string
            xorl %esi, %esi
            movb (%rax), %sil # sil (rsi) holds the length
            leaq 1(%rax), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf
            # second
            movq %r13, %rdi
            call swapCase
            leaq len_output(%rip), %rdi # rax holds the swapped string
            xorl %esi, %esi
            movb (%rax), %sil # sil (rsi) holds the length
            leaq 1(%rax), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf
            jmp func_end

        pstrijcpy_func:
            # create place in stack for local i j and alignment to 16
            subq $16, %rsp
            # scan i j
            leaq scanf_format(%rip),%rdi # arg1
            movq %rsp, %rsi 
            leaq 4(%rsp), %rdx
            xorl %eax, %eax
            call scanf

            xorq %rdx, %rdx
            xorq %rcx, %rcx
            movb (%rsp), %dl # dl = i
            movb 4(%rsp), %cl # cl = j

            movq %r12, %rdi
            movq %r13, %rsi

            call pstrijcpy
            addq $16, %rsp
    

            leaq len_output(%rip), %rdi
            xorl %esi, %esi
            movb (%r12), %sil # sil (rsi) holds the length
            leaq 1(%r12), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf

            leaq len_output(%rip), %rdi
            xorl %esi, %esi
            movb (%r13), %sil # sil (rsi) holds the length
            leaq 1(%r13), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf
            jmp func_end

        pstrcmp_func:
            # Implementation for pstrcmp (Choice 41)
            movq %r12, %rdi
            movq %r13, %rsi
            call pstrcmp
            cmpq $0, %rax
            jg high_value
            jl low_value
            leaq equal_cmp(%rip), %rdi
            xorl %eax, %eax
            call printf
            jmp func_end

            high_value:
                leaq high_cmp(%rip), %rdi
                xorl %eax, %eax
                call printf
                jmp func_end

            low_value:
                leaq low_cmp(%rip), %rdi
                xorl %eax, %eax
                call printf
                jmp func_end




             

            jmp func_end

        pstrrev_func:
             # first string and print
            movq %r12, %rdi
            call pstrrev
            leaq len_output(%rip), %rdi # rax holds the string
            xorl %esi, %esi
            movb (%rax), %sil # sil (rsi) holds the length
            leaq 1(%rax), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf
            # second
            movq %r13, %rdi
            call pstrrev
            leaq len_output(%rip), %rdi # rax holds the swapped string
            xorl %esi, %esi
            movb (%rax), %sil # sil (rsi) holds the length
            leaq 1(%rax), %rdx # rdx holds the string itself
            xorl %eax, %eax
            call printf
            jmp func_end
        func_end:
            pop %r13
            pop %r12
            popq %rbp
            ret













