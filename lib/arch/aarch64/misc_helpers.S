/*
 * Copyright (c) 2013, ARM Limited. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of ARM nor the names of its contributors may be used
 * to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <arch_helpers.h>

	.globl	enable_irq
	.globl	disable_irq

	.globl	enable_fiq
	.globl	disable_fiq

	.globl	enable_serror
	.globl	disable_serror

	.globl	read_daif
	.globl	write_daif

	.globl	read_spsr
	.globl	read_spsr_el1
	.globl	read_spsr_el2
	.globl	read_spsr_el3

	.globl	write_spsr
	.globl	write_spsr_el1
	.globl	write_spsr_el2
	.globl	write_spsr_el3

	.globl	read_elr
	.globl	read_elr_el1
	.globl	read_elr_el2
	.globl	read_elr_el3

	.globl	write_elr
	.globl	write_elr_el1
	.globl	write_elr_el2
	.globl	write_elr_el3

	.globl	get_afflvl_shift
	.globl	mpidr_mask_lower_afflvls
	.globl	dsb
	.globl	isb
	.globl	sev
	.globl	wfe
	.globl	wfi
	.globl	eret
	.globl	smc


	.section	.text, "ax"

get_afflvl_shift:; .type get_afflvl_shift, %function
	cmp	x0, #3
	cinc	x0, x0, eq
	mov	x1, #MPIDR_AFFLVL_SHIFT
	lsl	x0, x0, x1
	ret

mpidr_mask_lower_afflvls:; .type mpidr_mask_lower_afflvls, %function
	cmp	x1, #3
	cinc	x1, x1, eq
	mov	x2, #MPIDR_AFFLVL_SHIFT
	lsl	x2, x1, x2
	lsr	x0, x0, x2
	lsl	x0, x0, x2
	ret

	/* -----------------------------------------------------
	 * Asynchronous exception manipulation accessors
	 * -----------------------------------------------------
	 */
enable_irq:; .type enable_irq, %function
	msr	daifclr, #DAIF_IRQ_BIT
	ret


enable_fiq:; .type enable_fiq, %function
	msr	daifclr, #DAIF_FIQ_BIT
	ret


enable_serror:; .type enable_serror, %function
	msr	daifclr, #DAIF_ABT_BIT
	ret


disable_irq:; .type disable_irq, %function
	msr	daifset, #DAIF_IRQ_BIT
	ret


disable_fiq:; .type disable_fiq, %function
	msr	daifset, #DAIF_FIQ_BIT
	ret


disable_serror:; .type disable_serror, %function
	msr	daifset, #DAIF_ABT_BIT
	ret


read_daif:; .type read_daif, %function
	mrs	x0, daif
	ret


write_daif:; .type write_daif, %function
	msr	daif, x0
	ret


read_spsr:; .type read_spsr, %function
	mrs	x0, CurrentEl
	cmp	x0, #(MODE_EL1 << MODE_EL_SHIFT)
	b.eq	read_spsr_el1
	cmp	x0, #(MODE_EL2 << MODE_EL_SHIFT)
	b.eq	read_spsr_el2
	cmp	x0, #(MODE_EL3 << MODE_EL_SHIFT)
	b.eq	read_spsr_el3


read_spsr_el1:; .type read_spsr_el1, %function
	mrs	x0, spsr_el1
	ret


read_spsr_el2:; .type read_spsr_el2, %function
	mrs	x0, spsr_el2
	ret


read_spsr_el3:; .type read_spsr_el3, %function
	mrs	x0, spsr_el3
	ret


write_spsr:; .type write_spsr, %function
	mrs	x1, CurrentEl
	cmp	x1, #(MODE_EL1 << MODE_EL_SHIFT)
	b.eq	write_spsr_el1
	cmp	x1, #(MODE_EL2 << MODE_EL_SHIFT)
	b.eq	write_spsr_el2
	cmp	x1, #(MODE_EL3 << MODE_EL_SHIFT)
	b.eq	write_spsr_el3


write_spsr_el1:; .type write_spsr_el1, %function
	msr	spsr_el1, x0
	isb
	ret


write_spsr_el2:; .type write_spsr_el2, %function
	msr	spsr_el2, x0
	isb
	ret


write_spsr_el3:; .type write_spsr_el3, %function
	msr	spsr_el3, x0
	isb
	ret


read_elr:; .type read_elr, %function
	mrs	x0, CurrentEl
	cmp	x0, #(MODE_EL1 << MODE_EL_SHIFT)
	b.eq	read_elr_el1
	cmp	x0, #(MODE_EL2 << MODE_EL_SHIFT)
	b.eq	read_elr_el2
	cmp	x0, #(MODE_EL3 << MODE_EL_SHIFT)
	b.eq	read_elr_el3


read_elr_el1:; .type read_elr_el1, %function
	mrs	x0, elr_el1
	ret


read_elr_el2:; .type read_elr_el2, %function
	mrs	x0, elr_el2
	ret


read_elr_el3:; .type read_elr_el3, %function
	mrs	x0, elr_el3
	ret


write_elr:; .type write_elr, %function
	mrs	x1, CurrentEl
	cmp	x1, #(MODE_EL1 << MODE_EL_SHIFT)
	b.eq	write_elr_el1
	cmp	x1, #(MODE_EL2 << MODE_EL_SHIFT)
	b.eq	write_elr_el2
	cmp	x1, #(MODE_EL3 << MODE_EL_SHIFT)
	b.eq	write_elr_el3


write_elr_el1:; .type write_elr_el1, %function
	msr	elr_el1, x0
	isb
	ret


write_elr_el2:; .type write_elr_el2, %function
	msr	elr_el2, x0
	isb
	ret


write_elr_el3:; .type write_elr_el3, %function
	msr	elr_el3, x0
	isb
	ret


dsb:; .type dsb, %function
	dsb	sy
	ret


isb:; .type isb, %function
	isb
	ret


sev:; .type sev, %function
	sev
	ret


wfe:; .type wfe, %function
	wfe
	ret


wfi:; .type wfi, %function
	wfi
	ret


eret:; .type eret, %function
	eret


smc:; .type smc, %function
	smc	#0
