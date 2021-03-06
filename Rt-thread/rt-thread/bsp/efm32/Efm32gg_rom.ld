/***************************************************************************//**
 * @file 		efm32_rom_gg.ld
 * @brief 	Linker script for EFM32 giant gecko with GNU ld
 * 	COPYRIGHT (C) 2011, RT-Thread Development Team
 * @author 	onelife
 * @version 	0.4 beta
 *******************************************************************************
 * @section License
 * The license and distribution terms for this file may be found in the file
 * LICENSE in this distribution or at http://www.rt-thread.org/license/LICENSE
 *******************************************************************************
 * @section Change Logs
 * Date			Author		Notes
 * 2011-12-08	onelife		Initial creation for EFM3 giant gecko
 * 	support
 ******************************************************************************/
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
ENTRY(__cs3_reset)
SEARCH_DIR(.)
GROUP(-lgcc -lc -lcs3 -lcs3unhosted)

MEMORY
{
	CODE (rx) : ORIGIN = 0x00000000, LENGTH = 1024K
	DATA (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}
_system_stack_size = 0x200;

/* These force the linker to search for particular symbols from
 * the start of the link process and thus ensure the user's
 * overrides are picked up
 */

EXTERN(__cs3_reset __cs3_reset_efm32)
EXTERN(__cs3_start_asm _start)

PROVIDE(__cs3_reset = __cs3_reset_efm32);
PROVIDE(__cs3_start_asm = _start);

SECTIONS
{
	.text :
	{
		. = ALIGN(4);
		KEEP(*(.cs3.interrupt_vector))  /* Startup code */
		. = ALIGN(4);

		*(.cs3.reset)
		*(.cs3.init)
		*(.text)						/* remaining code */
		*(.text.*)						/* remaining code */
		*(.rodata)						/* read-only data (constants) */
		*(.rodata*)
		*(.glue_7)
		*(.glue_7t)
		*(.gnu.linkonce.t*)

		/* section information for finsh shell */
		. = ALIGN(4);
		__fsymtab_start = .;
		KEEP(*(FSymTab))
		__fsymtab_end = .;
		. = ALIGN(4);
		__vsymtab_start = .;
		KEEP(*(VSymTab))
		__vsymtab_end = .;
		. = ALIGN(4);

		. = ALIGN(4);
		_etext = .;
	} > CODE = 0

	/* .ARM.exidx is sorted, so has to go in its own output section.  */
	__exidx_start = .;
	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)

		/* This is used by the startup in order to initialize the .data secion */
		_sidata = .;
	} > CODE
	__exidx_end = .;

	/* .data section which is used for initialized data */
	.data : AT (_sidata)
	{
		. = ALIGN(4);
		/* This is used by the startup in order to initialize the .data secion */
		_sdata = . ;

		*(.data)
		*(.data.*)
		*(.gnu.linkonce.d*)

		. = ALIGN(4);
		/* This is used by the startup in order to initialize the .data secion */
		_edata = . ;
	} >DATA

	.stack :
	{
		. = . + _system_stack_size;
		. = ALIGN(4);
		__cs3_stack = .;
	} >DATA

	__bss_start = .;
	.bss :
	{
		. = ALIGN(4);
		/* This is used by the startup in order to initialize the .bss secion */
		_sbss = .;

		*(.bss)
		*(.bss.*)
		*(COMMON)

		. = ALIGN(4);
		/* This is used by the startup in order to initialize the .bss secion */
		_ebss = . ;

		*(.bss.init)
	} > DATA
	__bss_end = .;
	_end = .;

	/* Stabs debugging sections.  */
	.stab          0 : { *(.stab) }
	.stabstr       0 : { *(.stabstr) }
	.stab.excl     0 : { *(.stab.excl) }
	.stab.exclstr  0 : { *(.stab.exclstr) }
	.stab.index    0 : { *(.stab.index) }
	.stab.indexstr 0 : { *(.stab.indexstr) }
	.comment       0 : { *(.comment) }

	/* DWARF debug sections.
	* Symbols in the DWARF debugging sections are relative to
	* the beginning of the section so we begin them at 0.
	*/
	/* DWARF 1 */
	.debug          0 : { *(.debug) }
	.line           0 : { *(.line) }
	/* GNU DWARF 1 extensions */
	.debug_srcinfo  0 : { *(.debug_srcinfo) }
	.debug_sfnames  0 : { *(.debug_sfnames) }
	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges  0 : { *(.debug_aranges) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	/* DWARF 2 */
	.debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
	.debug_abbrev   0 : { *(.debug_abbrev) }
	.debug_line     0 : { *(.debug_line) }
	.debug_frame    0 : { *(.debug_frame) }
	.debug_str      0 : { *(.debug_str) }
	.debug_loc      0 : { *(.debug_loc) }
	.debug_macinfo  0 : { *(.debug_macinfo) }
	/* DWARF 2.1 */
	.debug_ranges   0 : { *(.debug_ranges) }
	/* SGI/MIPS DWARF 2 extensions */
	.debug_weaknames 0 : { *(.debug_weaknames) }
	.debug_funcnames 0 : { *(.debug_funcnames) }
	.debug_typenames 0 : { *(.debug_typenames) }
	.debug_varnames  0 : { *(.debug_varnames) }

	.note.gnu.arm.ident 0 : { KEEP (*(.note.gnu.arm.ident)) }
	.ARM.attributes 0 : { KEEP (*(.ARM.attributes)) }
	/DISCARD/ : { *(.note.GNU-stack) }
}

