handle_read:
.LFB20:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rdi), %rbx
	movq	160(%rbx), %rsi
	movq	152(%rbx), %rdx
	cmpq	%rdx, %rsi
	jb	.L393
	cmpq	$5000, %rdx
	ja	.L417
	addq	$1000, %rdx
	leaq	152(%rbx), %rsi
	leaq	144(%rbx), %rdi
	call	httpd_realloc_str
	movq	152(%rbx), %rdx
	movq	160(%rbx), %rsi
.L393:
	movl	704(%rbx), %edi
	subq	%rsi, %rdx
	addq	144(%rbx), %rsi
	call	read
	testl	%eax, %eax
	je	.L417
	jns	.L396
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L392
	cmpl	$11, %eax
	jne	.L417
.L392:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L396:
	.cfi_restore_state
	cltq
	addq	%rax, 160(%rbx)
	movq	(%r12), %rax
	movq	%rbx, %rdi
	movq	%rax, 88(%rbp)
	call	httpd_got_request
	testl	%eax, %eax
	je	.L392
	cmpl	$2, %eax
	jne	.L398
.L417:
	movl	$.LC44, %r9d
	movq	httpd_err400form(%rip), %r8
	movl	$400, %esi
	movq	%rbx, %rdi
	movq	httpd_err400title(%rip), %rdx
	movq	%r9, %rcx
	call	httpd_send_err
.L416:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L398:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L416
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L418
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L416
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L402
	movq	536(%rbx), %rax
	movq	%rax, 136(%rbp)
	movq	544(%rbx), %rax
	addq	$1, %rax
	movq	%rax, 128(%rbp)
.L403:
	cmpq	$0, 712(%rbx)
	je	.L419
	movq	128(%rbp), %rax
	cmpq	%rax, 136(%rbp)
	jge	.L416
	movq	(%r12), %rax
	movl	$2, 0(%rbp)
	movq	$0, 112(%rbp)
	movl	704(%rbx), %edi
	movq	%rax, 80(%rbp)
	call	fdwatch_del_fd
	movl	704(%rbx), %edi
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movl	$1, %edx
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L418:
	.cfi_restore_state
	movq	208(%rbx), %r9
	movq	httpd_err503form(%rip), %r8
	movl	$.LC44, %ecx
	movq	%rbx, %rdi
	movq	httpd_err503title(%rip), %rdx
	movl	$503, %esi
	call	httpd_send_err
	jmp	.L416
	.p2align 4,,10
	.p2align 3
.L402:
	movq	192(%rbx), %rax
	movl	$0, %edx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	movq	%rax, 128(%rbp)
	jmp	.L403
.L419:
	movl	56(%rbp), %eax
	movq	200(%rbx), %rsi
	testl	%eax, %eax
	jle	.L408
	subl	$1, %eax
	movq	throttles(%rip), %rcx
	leaq	16(%rbp), %rdx
	leaq	20(%rbp,%rax,4), %rdi
	.p2align 4,,10
	.p2align 3
.L407:
	movslq	(%rdx), %rax
	addq	$4, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rsi, 32(%rcx,%rax)
	cmpq	%rdx, %rdi
	jne	.L407
.L408:
	movq	%rsi, 136(%rbp)
	jmp	.L416
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata.str1.8
	.align 8
.LC89:
	.string	"%.80s connection timed out reading"
	.align 8
.LC90:
	.string	"%.80s connection timed out sending"
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L429
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movq	%rsi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	jmp	.L425
	.p2align 4,,10
	.p2align 3
.L434:
	testl	%eax, %eax
	jle	.L423
	cmpl	$3, %eax
	jg	.L423
	movq	(%r12), %rax
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L432
	.p2align 4,,10
	.p2align 3
.L423:
	addq	$1, %rbp
	cmpl	%ebp, max_connects(%rip)
	jle	.L433
.L425:
	leaq	0(%rbp,%rbp,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L434
	movq	(%r12), %rax
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L423
	movq	8(%rbx), %rax
	addq	$1, %rbp
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC89, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movl	$.LC44, %r9d
	movq	8(%rbx), %rdi
	movq	httpd_err408form(%rip), %r8
	movq	httpd_err408title(%rip), %rdx
	movq	%r9, %rcx
	movl	$408, %esi
	call	httpd_send_err
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	cmpl	%ebp, max_connects(%rip)
	jg	.L425
.L433:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L432:
	.cfi_restore_state
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC90, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	syslog
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L423
	.p2align 4,,10
	.p2align 3
.L429:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.8
	.align 8
.LC91:
	.string	"replacing non-null wakeup_timer!"
	.align 8
.LC92:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC93:
	.string	"write - %m sending %.80s"
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB21:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	$1000000000, %eax
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	64(%rdi), %rcx
	movq	8(%rdi), %r12
	cmpq	$-1, %rcx
	je	.L436
	testq	%rcx, %rcx
	leaq	3(%rcx), %rdx
	cmovns	%rcx, %rdx
	movq	%rdx, %rax
	sarq	$2, %rax
.L436:
	movq	136(%rbx), %rdx
	movq	128(%rbx), %rdi
	movq	712(%r12), %rsi
	movq	472(%r12), %rcx
	subq	%rdx, %rdi
	addq	%rdx, %rsi
	movq	%rdi, %rdx
	cmpq	%rax, %rdi
	movl	704(%r12), %edi
	cmova	%rax, %rdx
	testq	%rcx, %rcx
	jne	.L437
	call	write
	testl	%eax, %eax
	js	.L489
.L439:
	jne	.L490
.L458:
	addq	$100, 112(%rbx)
	movl	704(%r12), %edi
	movl	$3, (%rbx)
	call	fdwatch_del_fd
	cmpq	$0, 96(%rbx)
	je	.L442
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L442:
	movq	112(%rbx), %rcx
.L488:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$wakeup_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	movq	%rax, 96(%rbx)
	testq	%rax, %rax
	je	.L491
.L435:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L437:
	.cfi_restore_state
	movq	368(%r12), %rax
	movq	%rsi, 16(%rsp)
	movq	%rsp, %rsi
	movq	%rdx, 24(%rsp)
	movl	$2, %edx
	movq	%rax, (%rsp)
	movq	%rcx, 8(%rsp)
	call	writev
	testl	%eax, %eax
	jns	.L439
.L489:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L435
	cmpl	$11, %eax
	je	.L458
	cmpl	$32, %eax
	setne	%cl
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L443
	cmpl	$104, %eax
	je	.L443
	movq	208(%r12), %rdx
	movl	$.LC93, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L443:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L490:
	.cfi_restore_state
	movq	0(%rbp), %rdx
	movslq	%eax, %rsi
	movq	%rdx, 88(%rbx)
	movq	472(%r12), %rdx
	testq	%rdx, %rdx
	jne	.L445
.L446:
	movq	8(%rbx), %rdx
	movq	136(%rbx), %r9
	movq	200(%rdx), %rax
	addq	%rsi, %r9
	movq	%r9, 136(%rbx)
	addq	%rsi, %rax
	movq	%rax, 200(%rdx)
	movl	56(%rbx), %edx
	testl	%edx, %edx
	jle	.L452
	subl	$1, %edx
	movq	throttles(%rip), %rdi
	leaq	16(%rbx), %rcx
	leaq	20(%rbx,%rdx,4), %r8
	.p2align 4,,10
	.p2align 3
.L451:
	movslq	(%rcx), %rdx
	addq	$4, %rcx
	leaq	(%rdx,%rdx,2), %rdx
	salq	$4, %rdx
	addq	%rsi, 32(%rdi,%rdx)
	cmpq	%rcx, %r8
	jne	.L451
.L452:
	cmpq	128(%rbx), %r9
	jge	.L492
	movq	112(%rbx), %rdx
	cmpq	$100, %rdx
	jg	.L493
.L453:
	movq	64(%rbx), %rcx
	cmpq	$-1, %rcx
	je	.L435
	movq	0(%rbp), %rdx
	subq	80(%rbx), %rdx
	movq	%rdx, %r13
	je	.L461
	cqto
	idivq	%r13
.L454:
	cmpq	%rax, %rcx
	jge	.L435
	movl	$3, (%rbx)
	movl	704(%r12), %edi
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
	movq	200(%rax), %rax
	cqto
	idivq	64(%rbx)
	movl	%eax, %r12d
	subl	%r13d, %r12d
	cmpq	$0, 96(%rbx)
	je	.L455
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L455:
	movl	$500, %ecx
	testl	%r12d, %r12d
	jle	.L488
	movslq	%r12d, %r12
	imulq	$1000, %r12, %rcx
	jmp	.L488
	.p2align 4,,10
	.p2align 3
.L445:
	cmpq	%rsi, %rdx
	ja	.L494
	movq	$0, 472(%r12)
	subl	%edx, %eax
	movslq	%eax, %rsi
	jmp	.L446
	.p2align 4,,10
	.p2align 3
.L493:
	subq	$100, %rdx
	movq	%rdx, 112(%rbx)
	jmp	.L453
	.p2align 4,,10
	.p2align 3
.L461:
	movl	$1, %r13d
	jmp	.L454
	.p2align 4,,10
	.p2align 3
.L492:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	jmp	.L435
	.p2align 4,,10
	.p2align 3
.L494:
	subl	%eax, %edx
	movq	368(%r12), %rdi
	movslq	%edx, %r13
	addq	%rdi, %rsi
	movq	%r13, %rdx
	call	memmove
	movq	%r13, 472(%r12)
	xorl	%esi, %esi
	jmp	.L446
.L491:
	movl	$2, %edi
	movl	$.LC92, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	movq	$0, 104(%rdi)
	jmp	really_clear_connection
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$4096, %edx
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	subq	$4104, %rsp
	.cfi_def_cfa_offset 4128
	movq	8(%rdi), %rax
	movq	%rsp, %rsi
	movl	704(%rax), %edi
	call	read
	testl	%eax, %eax
	js	.L505
	je	.L498
.L496:
	addq	$4104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L505:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L496
	cmpl	$11, %eax
	je	.L496
.L498:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	really_clear_connection
	addq	$4104, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.1
.LC94:
	.string	"%d"
.LC95:
	.string	"getaddrinfo %.80s - %.80s"
.LC96:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.8
	.align 8
.LC97:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	movq	%rdx, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	$.LC94, %edx
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	movl	$10, %esi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movzwl	port(%rip), %ecx
	leaq	22(%rsp), %rdi
	movups	%xmm0, 36(%rsp)
	movups	%xmm0, 52(%rsp)
	movq	$0, 68(%rsp)
	movl	$0, 76(%rsp)
	movl	$1, 32(%rsp)
	movl	$1, 40(%rsp)
	call	snprintf
	leaq	8(%rsp), %rcx
	leaq	32(%rsp), %rdx
	movq	hostname(%rip), %rdi
	leaq	22(%rsp), %rsi
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L523
	movq	8(%rsp), %r14
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	movq	%r14, %rax
	testq	%r14, %r14
	jne	.L508
	jmp	.L524
	.p2align 4,,10
	.p2align 3
.L526:
	cmpl	$10, %edx
	jne	.L511
	testq	%rsi, %rsi
	cmove	%rax, %rsi
.L511:
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L525
.L508:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L526
	testq	%r13, %r13
	cmove	%rax, %r13
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L508
.L525:
	testq	%rsi, %rsi
	je	.L527
	movl	16(%rsi), %r8d
	cmpq	$128, %r8
	ja	.L522
	movl	$16, %ecx
	movq	%r15, %rdi
	rep stosq
	movq	%r15, %rdi
	movl	16(%rsi), %edx
	movq	24(%rsi), %rsi
	call	memmove
	movl	$1, (%r12)
.L513:
	testq	%r13, %r13
	je	.L509
	movl	16(%r13), %r8d
	cmpq	$128, %r8
	ja	.L522
	xorl	%eax, %eax
	movl	$16, %ecx
	movq	%rbx, %rdi
	rep stosq
	movq	%rbx, %rdi
	movl	16(%r13), %edx
	movq	24(%r13), %rsi
	call	memmove
	movl	$1, 0(%rbp)
.L516:
	movq	%r14, %rdi
	call	freeaddrinfo
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L524:
	.cfi_restore_state
	movl	$0, (%r12)
.L509:
	movl	$0, 0(%rbp)
	jmp	.L516
.L527:
	movl	$0, (%r12)
	jmp	.L513
.L522:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	xorl	%eax, %eax
	movl	$.LC97, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L523:
	movl	%eax, %edi
	movl	%eax, %r13d
	call	gai_strerror
	movl	$.LC95, %esi
	movl	$2, %edi
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	xorl	%eax, %eax
	call	syslog
	movl	%r13d, %edi
	call	gai_strerror
	movq	stderr(%rip), %rdi
	movl	$.LC96, %esi
	movq	hostname(%rip), %rcx
	movq	argv0(%rip), %rdx
	movq	%rax, %r8
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.1
.LC98:
	.string	"can't find any valid address"
	.section	.rodata.str1.8
	.align 8
.LC99:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC100:
	.string	"unknown user - '%.80s'"
.LC101:
	.string	"%s: unknown user - '%s'\n"
.LC102:
	.string	"/dev/null"
	.section	.rodata.str1.8
	.align 8
.LC103:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 8
.LC104:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC105:
	.string	"fchown logfile - %m"
.LC106:
	.string	"fchown logfile"
.LC107:
	.string	"chdir - %m"
.LC108:
	.string	"chdir"
.LC109:
	.string	"daemon - %m"
.LC110:
	.string	"w"
.LC111:
	.string	"%d\n"
	.section	.rodata.str1.8
	.align 8
.LC112:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC113:
	.string	"chroot - %m"
	.section	.rodata.str1.8
	.align 8
.LC114:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 8
.LC115:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC116:
	.string	"chroot chdir - %m"
.LC117:
	.string	"chroot chdir"
.LC118:
	.string	"data_dir chdir - %m"
.LC119:
	.string	"data_dir chdir"
.LC120:
	.string	"tmr_create(occasional) failed"
.LC121:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.8
	.align 8
.LC122:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC123:
	.string	"tmr_create(show_stats) failed"
.LC124:
	.string	"setgroups - %m"
.LC125:
	.string	"setgid - %m"
.LC126:
	.string	"initgroups - %m"
.LC127:
	.string	"setuid - %m"
	.section	.rodata.str1.8
	.align 8
.LC128:
	.string	"started as root without requesting chroot(), warning only"
	.align 8
.LC129:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC130:
	.string	"fdwatch - %m"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4424, %rsp
	.cfi_def_cfa_offset 4480
	movq	(%rsi), %rbx
	movl	$47, %esi
	movq	%rbx, %rdi
	movq	%rbx, argv0(%rip)
	call	strrchr
	movl	$9, %esi
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	cmovne	%rdx, %rbx
	movl	$24, %edx
	movq	%rbx, %rdi
	leaq	176(%rsp), %rbx
	call	openlog
	movl	%r12d, %edi
	movq	%rbp, %rsi
	leaq	48(%rsp), %r12
	call	parse_args
	call	tzset
	leaq	28(%rsp), %rcx
	movq	%rbx, %rdx
	movq	%r12, %rdi
	leaq	24(%rsp), %rsi
	call	lookup_hostname.constprop.1
	movl	24(%rsp), %eax
	orl	28(%rsp), %eax
	je	.L657
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L531
	call	read_throttlefile
.L531:
	call	getuid
	movl	$32767, %r14d
	movl	$32767, %r15d
	testl	%eax, %eax
	je	.L658
.L532:
	movq	logfile(%rip), %rbp
	testq	%rbp, %rbp
	je	.L598
	movl	$.LC102, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L535
	movl	$1, no_log(%rip)
	xorl	%r13d, %r13d
.L534:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L540
	call	chdir
	testl	%eax, %eax
	js	.L659
.L540:
	leaq	304(%rsp), %rbp
	movl	$4096, %esi
	movq	%rbp, %rdi
	call	getcwd
	orq	$-1, %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdi
	repnz scasb
	movq	%rcx, %rdx
	notq	%rdx
	movq	%rdx, %rcx
	subq	$1, %rcx
	cmpb	$47, 303(%rsp,%rcx)
	je	.L541
	movw	$47, 0(%rbp,%rcx)
.L541:
	cmpl	$0, debug(%rip)
	jne	.L542
	movq	stdin(%rip), %rdi
	call	fclose
	movq	stdout(%rip), %rdi
	cmpq	%r13, %rdi
	je	.L543
	call	fclose
.L543:
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	movl	$.LC109, %esi
	testl	%eax, %eax
	js	.L655
.L544:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L545
	movl	$.LC110, %esi
	call	fopen
	testq	%rax, %rax
	je	.L660
	movq	%rax, (%rsp)
	call	getpid
	movq	(%rsp), %rcx
	movl	$.LC111, %esi
	movl	%eax, %edx
	xorl	%eax, %eax
	movq	%rcx, %rdi
	call	fprintf
	movq	(%rsp), %rcx
	movq	%rcx, %rdi
	call	fclose
.L545:
	call	fdwatch_get_nfiles
	movl	%eax, max_connects(%rip)
	testl	%eax, %eax
	js	.L661
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L662
.L548:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L552
	call	chdir
	testl	%eax, %eax
	js	.L663
.L552:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	movl	no_empty_referers(%rip), %eax
	xorl	%esi, %esi
	movq	%rbx, %rdx
	cmpl	$0, 28(%rsp)
	movzwl	port(%rip), %ecx
	cmove	%rsi, %rdx
	cmpl	$0, 24(%rsp)
	pushq	%rax
	.cfi_def_cfa_offset 4488
	movl	do_global_passwd(%rip), %eax
	pushq	local_pattern(%rip)
	.cfi_def_cfa_offset 4496
	cmovne	%r12, %rsi
	movl	cgi_limit(%rip), %r9d
	pushq	url_pattern(%rip)
	.cfi_def_cfa_offset 4504
	movq	cgi_pattern(%rip), %r8
	pushq	%rax
	.cfi_def_cfa_offset 4512
	movl	do_vhost(%rip), %eax
	movq	hostname(%rip), %rdi
	pushq	%rax
	.cfi_def_cfa_offset 4520
	movl	no_symlink_check(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 4528
	movl	no_log(%rip), %eax
	pushq	%r13
	.cfi_def_cfa_offset 4536
	pushq	%rax
	.cfi_def_cfa_offset 4544
	movl	max_age(%rip), %eax
	pushq	%rbp
	.cfi_def_cfa_offset 4552
	pushq	%rax
	.cfi_def_cfa_offset 4560
	pushq	p3p(%rip)
	.cfi_def_cfa_offset 4568
	pushq	charset(%rip)
	.cfi_def_cfa_offset 4576
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4480
	movq	%rax, hs(%rip)
	testq	%rax, %rax
	je	.L656
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	movl	$occasional, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L664
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L665
	cmpl	$0, numthrottles(%rip)
	jle	.L558
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	movl	$update_throttles, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L666
.L558:
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	movl	$show_stats, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L667
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	jne	.L561
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	movl	$.LC124, %esi
	testl	%eax, %eax
	js	.L655
	movl	%r14d, %edi
	call	setgid
	movl	$.LC125, %esi
	testl	%eax, %eax
	js	.L655
	movq	user(%rip), %rdi
	movl	%r14d, %esi
	call	initgroups
	testl	%eax, %eax
	js	.L668
.L564:
	movl	%r15d, %edi
	call	setuid
	movl	$.LC127, %esi
	testl	%eax, %eax
	js	.L655
	cmpl	$0, do_chroot(%rip)
	jne	.L561
	movl	$.LC128, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
.L561:
	movslq	max_connects(%rip), %rbp
	movq	%rbp, %rbx
	imulq	$144, %rbp, %rbp
	movq	%rbp, %rdi
	call	malloc
	movq	%rax, connects(%rip)
	testq	%rax, %rax
	je	.L567
	movq	%rax, %rdx
	xorl	%ecx, %ecx
	jmp	.L568
.L569:
	addl	$1, %ecx
	movl	$0, (%rdx)
	addq	$144, %rdx
	movl	%ecx, -140(%rdx)
	movq	$0, -136(%rdx)
.L568:
	cmpl	%ecx, %ebx
	jg	.L569
	movl	$-1, -140(%rax,%rbp)
	movq	hs(%rip), %rax
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L571
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L572
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L572:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L571
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L571:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
.L574:
	cmpl	$0, terminate(%rip)
	je	.L596
	cmpl	$0, num_connects(%rip)
	jle	.L669
.L596:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L670
.L575:
	leaq	32(%rsp), %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	movl	%eax, %ebx
	testl	%eax, %eax
	jns	.L576
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L574
	cmpl	$11, %eax
	je	.L574
	movl	$3, %edi
	movl	$.LC130, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L535:
	movl	$.LC77, %esi
	movq	%rbp, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L536
	movq	stdout(%rip), %r13
	jmp	.L534
.L661:
	movl	$.LC112, %esi
.L655:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
.L656:
	movl	$1, %edi
	call	exit
.L542:
	call	setsid
	jmp	.L544
.L658:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L671
	movl	16(%rax), %r15d
	movl	20(%rax), %r14d
	jmp	.L532
.L598:
	xorl	%r13d, %r13d
	jmp	.L534
.L536:
	movq	%rbp, %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movl	$384, %esi
	movq	%rax, %r13
	movq	%rbp, %rdi
	call	chmod
	testq	%r13, %r13
	je	.L601
	testl	%eax, %eax
	jne	.L601
	cmpb	$47, 0(%rbp)
	jne	.L672
.L539:
	movq	%r13, %rdi
	call	fileno
	movl	$1, %edx
	movl	$2, %esi
	movl	%eax, %edi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L534
	movq	%r13, %rdi
	call	fileno
	movl	%r14d, %edx
	movl	%r15d, %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L534
	movl	$.LC105, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC106, %edi
	call	perror
	jmp	.L534
.L657:
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	movl	$.LC99, %esi
	call	fprintf
	movl	$1, %edi
	call	exit
.L659:
	movl	$.LC107, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC108, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L660:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC69, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L662:
	movq	%rbp, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L673
	movq	logfile(%rip), %r8
	testq	%r8, %r8
	je	.L550
	movl	$.LC77, %esi
	movq	%r8, %rdi
	movq	%r8, (%rsp)
	call	strcmp
	testl	%eax, %eax
	je	.L550
	orq	$-1, %rcx
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movq	(%rsp), %r8
	repnz scasb
	movq	%rbp, %rsi
	movq	%r8, %rdi
	movq	%rcx, %rdx
	notq	%rdx
	movq	%rdx, %rcx
	leaq	-1(%rdx), %rdx
	movq	%rcx, 8(%rsp)
	call	strncmp
	testl	%eax, %eax
	jne	.L551
	movq	(%rsp), %r8
	movq	8(%rsp), %rcx
	movq	%r8, %rdi
	leaq	-2(%r8,%rcx), %rsi
	call	strcpy
.L550:
	movw	$47, 304(%rsp)
	movq	%rbp, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L548
	movl	$.LC116, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC117, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L663:
	movl	$.LC118, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC119, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L672:
	xorl	%eax, %eax
	movl	$.LC103, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$.LC104, %esi
	call	fprintf
	jmp	.L539
.L666:
	movl	$2, %edi
	movl	$.LC122, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L671:
	movq	user(%rip), %rdx
	movl	$.LC100, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movl	$.LC101, %esi
	xorl	%eax, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	call	fprintf
	movl	$1, %edi
	call	exit
.L664:
	movl	$2, %edi
	movl	$.LC120, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L576:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L674
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L588
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L583
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L584
.L587:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L588
.L583:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L588
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L588
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	72(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L574
.L588:
	call	fdwatch_get_next_client_data
	movq	%rax, %rbx
	cmpq	$-1, %rax
	je	.L675
	testq	%rbx, %rbx
	je	.L588
	movq	8(%rbx), %rax
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L676
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L591
	cmpl	$4, %eax
	je	.L592
	subl	$1, %eax
	jne	.L588
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L588
.L676:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L588
.L670:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L575
.L601:
	movq	%rbp, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L673:
	movl	$.LC113, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC17, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L667:
	movl	$2, %edi
	movl	$.LC123, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L675:
	leaq	32(%rsp), %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L574
	cmpl	$0, terminate(%rip)
	jne	.L574
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L574
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L594
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L594:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L595
	call	fdwatch_del_fd
.L595:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L574
.L592:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L588
.L591:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L588
.L665:
	movl	$2, %edi
	movl	$.LC121, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L551:
	xorl	%eax, %eax
	movl	$.LC114, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$.LC115, %esi
	call	fprintf
	jmp	.L550
.L674:
	leaq	32(%rsp), %rdi
	call	tmr_run
	jmp	.L574
.L567:
	movl	$.LC129, %esi
	jmp	.L655
.L584:
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	76(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	je	.L587
	jmp	.L574
.L669:
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
.L668:
	movl	$.LC126, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L564
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,8,8
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,8,8
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,8,8
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,8,8
	.local	charset
	.comm	charset,8,8
	.local	user
	.comm	user,8,8
	.local	pidfile
	.comm	pidfile,8,8
	.local	hostname
	.comm	hostname,8,8
	.local	throttlefile
	.comm	throttlefile,8,8
	.local	logfile
	.comm	logfile,8,8
	.local	local_pattern
	.comm	local_pattern,8,8
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,8,8
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,8,8
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,8,8
	.local	dir
	.comm	dir,8,8
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,8,8
	.ident	"GCC: (GNU) 8.2.0"
	.section	.note.GNU-stack,"",@progbits
