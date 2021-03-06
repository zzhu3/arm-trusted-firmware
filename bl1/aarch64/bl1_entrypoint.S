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


	.globl	reset_handler


	.section	reset_code, "ax"; .align 3

	/* -----------------------------------------------------
	 * reset_handler() is the entry point into the trusted
	 * firmware code when a cpu is released from warm or
	 * cold reset.
	 * -----------------------------------------------------
	 */

reset_handler:; .type reset_handler, %function
	/* ---------------------------------------------
	 * Perform any processor specific actions upon
	 * reset e.g. cache, tlb invalidations etc.
	 * ---------------------------------------------
	 */
	bl	cpu_reset_handler

_wait_for_entrypoint:
	/* ---------------------------------------------
	 * Find the type of reset and jump to handler
	 * if present. If the handler is null then it is
	 * a cold boot. The primary cpu will set up the
	 * platform while the secondaries wait for
	 * their turn to be woken up
	 * ---------------------------------------------
	 */
	bl	read_mpidr
	bl	platform_get_entrypoint
	cbnz	x0, _do_warm_boot
	bl	read_mpidr
	bl	platform_is_primary_cpu
	cbnz	x0, _do_cold_boot

	/* ---------------------------------------------
	 * Perform any platform specific secondary cpu
	 * actions
	 * ---------------------------------------------
	 */
	bl	plat_secondary_cold_boot_setup
	b	_wait_for_entrypoint

_do_cold_boot:
	/* ---------------------------------------------
	 * Initialize platform and jump to our c-entry
	 * point for this type of reset
	 * ---------------------------------------------
	 */
	adr	x0, bl1_main
	bl	platform_cold_boot_init
	b	_panic

_do_warm_boot:
	/* ---------------------------------------------
	 * Jump to BL31 for all warm boot init.
	 * ---------------------------------------------
	 */
	blr	x0
_panic:
	b	_panic
