From: Andre Noll <maan@systemlinux.org>
Subject: Re: INFO: possible recursive locking detected. Was: more
	than 10 shapshots freeze system
Date: Wed, 28 Feb 2007 18:45:23 +0100
Message-ID: <20070228174523.GK22572@skl-net.de>
References: <20070212174702.GG19569@skl-net.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1131891656=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070212174702.GG19569@skl-net.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Heinz Mauelshagen <mauelshagen@redhat.com>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids


--===============1131891656==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cf0hFtnykp6aONGL"
Content-Disposition: inline


--cf0hFtnykp6aONGL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:47, Andre Noll wrote:

[problems with snapshots]

No response, so here's some more info:

	- the problem remains with 2.6.20.1 and 2.6.21-rc2

	- Writing to the lv from which a couple of snapshots
	  were taken results in a kernel panic within minutes
	  on 2.6.21-rc2. Screenshot:

  	  http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png

	- Sometimes the system locks up without panicing. In this case
	  it still responds to Alt + SysRq, is pingable, but otherwise
	  dead (impossible to ssh in, no response on keyboard, no disk io)

	- 2.6.21-rc2 seems to have dm-related locking problems, see below

Thanks
Andre


[    0.000000] Linux version 2.6.21-rc2 (root@huangho2) (gcc version 4.0.3 =
(Ubuntu 4.0.3-1ubuntu5)) #39 SMP Wed Feb 28 14:19:48 CET 2007
[    0.000000] Command line:=20
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000f57f8000 (usable)
[    0.000000]  BIOS-e820: 00000000f57f8000 - 00000000f5800000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fdc00000 - 00000000fdc01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fdc10000 - 00000000fdc11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec20000 - 00000000fec21000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013ffff000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 1005560) 1 entries of 3200=
 used
[    0.000000] Entering add_active_range(0, 1048576, 1310719) 2 entries of =
3200 used
[    0.000000] end_pfn_map =3D 1310719
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F4F20, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT F57F83E0, 0044 (r1 HP     A05             2   =D2=
=04     162E)
[    0.000000] ACPI: FACP F57F8460, 00F4 (r3 HP     A05             2   =D2=
=04     162E)
[    0.000000] ACPI: DSDT F57F8560, 422D (r1 HP         DSDT        1 MSFT =
 2000001)
[    0.000000] ACPI: FACS F57F80C0, 0040
[    0.000000] ACPI: APIC F57F8100, 00B8 (r1 HP     00000083        2      =
       0)
[    0.000000] ACPI: SPCR F57F81E0, 0050 (r1 HP     SPCRRBSU        1   =D2=
=04     162E)
[    0.000000] ACPI: SRAT F57F8260, 0150 (r1 HP     A05             1      =
       0)
[    0.000000] SRAT: PXM 1 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 2 -> Node 1
[    0.000000] ACPI: [SRAT:0x00] ignored 4 entries of 8 found
[    0.000000] SRAT: Node 0 PXM 1 0-c0000000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 786432) 1 entries of 3200 =
used
[    0.000000] SRAT: Node 1 PXM 2 c0000000-140000000
[    0.000000] Entering add_active_range(1, 786432, 1005560) 2 entries of 3=
200 used
[    0.000000] Entering add_active_range(1, 1048576, 1310719) 3 entries of =
3200 used
[    0.000000] NUMA: Using 30 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-00000000c0000000
[    0.000000] Bootmem setup node 1 00000000c0000000-000000013ffff000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1310719
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786432
[    0.000000]     1:   786432 ->  1005560
[    0.000000]     1:  1048576 ->  1310719
[    0.000000] On node 0 totalpages: 786335
[    0.000000]   DMA zone: 88 pages used for memmap
[    0.000000]   DMA zone: 2643 pages reserved
[    0.000000]   DMA zone: 1268 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16808 pages used for memmap
[    0.000000]   DMA32 zone: 765528 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 481271
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 5632 pages used for memmap
[    0.000000]   DMA32 zone: 213496 pages, LIFO batch:31
[    0.000000]   Normal zone: 5631 pages used for memmap
[    0.000000]   Normal zone: 256512 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, address 0xfec10000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec20000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 6, address 0xfec20000, GSI 28-31
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfdc00000] gsi_base[32])
[    0.000000] IOAPIC[3]: apic_id 7, address 0xfdc00000, GSI 32-35
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfdc10000] gsi_base[36])
[    0.000000] IOAPIC[4]: apic_id 8, address 0xfdc10000, GSI 36-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000f0000
[    0.000000] Nosave address range: 00000000000f0000 - 0000000000100000
[    0.000000] Nosave address range: 00000000f57f8000 - 00000000f5800000
[    0.000000] Nosave address range: 00000000f5800000 - 00000000fdc00000
[    0.000000] Nosave address range: 00000000fdc00000 - 00000000fdc01000
[    0.000000] Nosave address range: 00000000fdc01000 - 00000000fdc10000
[    0.000000] Nosave address range: 00000000fdc10000 - 00000000fdc11000
[    0.000000] Nosave address range: 00000000fdc11000 - 00000000fec00000
[    0.000000] Nosave address range: 00000000fec00000 - 00000000fec01000
[    0.000000] Nosave address range: 00000000fec01000 - 00000000fec10000
[    0.000000] Nosave address range: 00000000fec10000 - 00000000fec11000
[    0.000000] Nosave address range: 00000000fec11000 - 00000000fec20000
[    0.000000] Nosave address range: 00000000fec20000 - 00000000fec21000
[    0.000000] Nosave address range: 00000000fec21000 - 00000000fee00000
[    0.000000] Nosave address range: 00000000fee00000 - 00000000fee10000
[    0.000000] Nosave address range: 00000000fee10000 - 00000000ff800000
[    0.000000] Nosave address range: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f6000000 (gap: f5800000=
:8400000)
[    0.000000] PERCPU: Allocating 34176 bytes of per cpu data
[    0.000000] Built 2 zonelists.  Total pages: 1236804
[    0.000000] Kernel command line:=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[   60.011565] time.c: Detected 2205.042 MHz processor.
[   60.014387] Console: colour VGA+ 80x25
[   60.027154] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[   60.027343] ... MAX_LOCKDEP_SUBCLASSES:    8
[   60.027459] ... MAX_LOCK_DEPTH:          30
[   60.027585] ... MAX_LOCKDEP_KEYS:        2048
[   60.027712] ... CLASSHASH_SIZE:           1024
[   60.027839] ... MAX_LOCKDEP_ENTRIES:     8192
[   60.027985] ... MAX_LOCKDEP_CHAINS:      16384
[   60.028112] ... CHAINHASH_SIZE:          8192
[   60.028239]  memory used by lock dependency info: 1648 kB
[   60.028373]  per task-struct memory footprint: 1680 bytes
[   60.028504] ------------------------
[   60.028626] | Locking API testsuite:
[   60.028751] ------------------------------------------------------------=
----------------
[   60.028958]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[   60.029150]   ----------------------------------------------------------=
----------------
[   60.029345]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.030804]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.032266]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.033792]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.035317]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.036960]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.038567]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.040132]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.041467]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.042814]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   60.044216]   ----------------------------------------------------------=
----------------
[   60.044369]               recursive read-lock:             |  ok  |     =
        |  ok  |
[   60.045068]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[   60.045777]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[   60.046483]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[   60.047203]   ----------------------------------------------------------=
----------------
[   60.047355]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   60.048089]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   60.048825]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   60.049586]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   60.050322]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[   60.051057]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[   60.051791]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   60.052524]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   60.053259]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   60.054004]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   60.054739]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   60.055503]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   60.056266]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   60.057027]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   60.057799]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   60.058562]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   60.059325]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   60.060079]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   60.060836]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   60.061588]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   60.062331]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   60.063086]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   60.063842]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   60.064597]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   60.065355]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   60.066212]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   60.066970]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   60.067724]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   60.068483]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   60.069231]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   60.069995]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   60.070746]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   60.071506]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   60.072256]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   60.073008]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   60.073774]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   60.074534]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   60.075286]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   60.077757]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   60.078512]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   60.079273]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   60.080021]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   60.080775]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   60.081539]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   60.082300]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   60.083050]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   60.083804]       hard-irq read-recursion/123:  ok  |
[   60.084164]       soft-irq read-recursion/123:  ok  |
[   60.084525]       hard-irq read-recursion/132:  ok  |
[   60.084894]       soft-irq read-recursion/132:  ok  |
[   60.085255]       hard-irq read-recursion/213:  ok  |
[   60.085625]       soft-irq read-recursion/213:  ok  |
[   60.085986]       hard-irq read-recursion/231:  ok  |
[   60.086346]       soft-irq read-recursion/231:  ok  |
[   60.086707]       hard-irq read-recursion/312:  ok  |
[   60.087067]       soft-irq read-recursion/312:  ok  |
[   60.087428]       hard-irq read-recursion/321:  ok  |
[   60.087788]       soft-irq read-recursion/321:  ok  |
[   60.088166] -------------------------------------------------------
[   60.088280] Good, all 218 testcases passed! |
[   60.088386] ---------------------------------
[   60.093055] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[   60.100645] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[   60.103301] Checking aperture...
[   60.103406] CPU 0: aperture @ 8000000 size 32 MB
[   60.103513] Aperture too small (32 MB)
[   60.110468] No AGP bridge found
[   60.110569] Your BIOS doesn't leave a aperture memory hole
[   60.110679] Please enable the IOMMU option in the BIOS setup
[   60.110791] This costs you 64 MB of RAM
[   60.148054] Mapping aperture over 65536 KB of RAM @ 8000000
[   60.220565] Memory: 4871608k/5242876k available (3191k kernel code, 1988=
16k reserved, 1506k data, 1560k init)
[   60.301335] Calibrating delay using timer specific routine.. 4415.63 Bog=
oMIPS (lpj=3D8831279)
[   60.302065] Mount-cache hash table entries: 256
[   60.303162] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   60.303280] CPU: L2 Cache: 1024K (64 bytes/line)
[   60.303388] CPU 0/0 -> Node 0
[   60.303489] CPU: Physical Processor ID: 0
[   60.303594] CPU: Processor Core ID: 0
[   60.303709] Freeing SMP alternatives: 28k freed
[   60.303831] ACPI: Core revision 20070126
[   60.354197] Using local APIC timer interrupts.
[   60.399617] result 12528651
[   60.399716] Detected 12.528 MHz APIC timer.
[   60.402631] lockdep: not fixing up alternatives.
[   60.402859] Booting processor 1/4 APIC 0x2
[   60.413270] Initializing CPU#1
[   60.493172] Calibrating delay using timer specific routine.. 4410.33 Bog=
oMIPS (lpj=3D8820661)
[   60.493179] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   60.493182] CPU: L2 Cache: 1024K (64 bytes/line)
[   60.493184] CPU 1/2 -> Node 1
[   60.493186] CPU: Physical Processor ID: 1
[   60.493187] CPU: Processor Core ID: 0
[   60.493196] AMD Opteron(tm) Processor 275 stepping 02
[   60.498040] lockdep: not fixing up alternatives.
[   60.499068] Booting processor 2/4 APIC 0x1
[   60.509474] Initializing CPU#2
[   60.589095] Calibrating delay using timer specific routine.. 4410.36 Bog=
oMIPS (lpj=3D8820730)
[   60.589101] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   60.589103] CPU: L2 Cache: 1024K (64 bytes/line)
[   60.589106] CPU 2/1 -> Node 0
[   60.589108] CPU: Physical Processor ID: 0
[   60.589109] CPU: Processor Core ID: 1
[   60.589115] AMD Opteron(tm) Processor 275 stepping 02
[   60.594169] lockdep: not fixing up alternatives.
[   60.595207] Booting processor 3/4 APIC 0x3
[   60.606128] Initializing CPU#3
[   60.685018] Calibrating delay using timer specific routine.. 4410.35 Bog=
oMIPS (lpj=3D8820706)
[   60.685026] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   60.685028] CPU: L2 Cache: 1024K (64 bytes/line)
[   60.685030] CPU 3/3 -> Node 1
[   60.685032] CPU: Physical Processor ID: 1
[   60.685034] CPU: Processor Core ID: 1
[   60.685042] AMD Opteron(tm) Processor 275 stepping 02
[   60.689051] Brought up 4 CPUs
[   60.690146] testing NMI watchdog ... OK.
[   62.181374] migration_cost=3D342,388
[   62.182752] NET: Registered protocol family 16
[   62.183361] ACPI: bus type pci registered
[   62.183477] PCI: Using configuration type 1
[   62.199903] ACPI: SSDT F57FD000, 059D (r1 HP        SSDT0        1 MSFT =
 2000001)
[   62.200597] ACPI: SSDT F57FD700, 059D (r1 HP        SSDT1        1 MSFT =
 2000001)
[   62.201286] ACPI: SSDT F57FDE00, 059D (r1 HP        SSDT2        1 MSFT =
 2000001)
[   62.201978] ACPI: SSDT F57FE500, 059D (r1 HP        SSDT3        1 MSFT =
 2000001)
[   62.202964] ACPI: Interpreter enabled
[   62.203068] ACPI: Using IOAPIC for interrupt routing
[   62.219075] ACPI: PCI Root Bridge [CFG0] (0000:00)
[   62.219217] PCI: Probing PCI hardware (bus 00)
[   62.220855] Boot video device is 0000:01:03.0
[   62.221528] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0._PRT]
[   62.221804] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI0._PRT]
[   62.222245] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI1._PRT]
[   62.222498] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI2._PRT]
[   62.233327] ACPI: PCI Root Bridge [CFG1] (0000:04)
[   62.233440] PCI: Probing PCI hardware (bus 04)
[   62.234321] ACPI: PCI Interrupt Routing Table [\_SB_.CFG1.PCI3._PRT]
[   62.235257] ACPI: PCI Interrupt Routing Table [\_SB_.CFG1.PCI4._PRT]
[   62.238167] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 7 *10 11)
[   62.238843] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 10 *11)
[   62.239507] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 11) *0, disab=
led.
[   62.240433] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
[   62.241164] Linux Plug and Play Support v0.97 (c) Adam Belay
[   62.241307] pnp: PnP ACPI init
[   62.251012] pnp: PnP ACPI: found 10 devices
[   62.252581] SCSI subsystem initialized
[   62.252972] usbcore: registered new interface driver usbfs
[   62.253229] usbcore: registered new interface driver hub
[   62.253505] usbcore: registered new device driver usb
[   62.253734] PCI: Using ACPI for IRQ routing
[   62.253840] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   62.254447] PCI-DMA: Disabling AGP.
[   62.254604] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   62.254715] PCI-DMA: using GART IOMMU.
[   62.254820] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   62.255163] pnp: 00:01: ioport range 0x230-0x233 has been reserved
[   62.255279] pnp: 00:01: ioport range 0x260-0x267 has been reserved
[   62.255395] pnp: 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   62.256784] PCI: Bridge: 0000:00:03.0
[   62.256889]   IO window: 4000-4fff
[   62.256996]   MEM window: f5f00000-f7cfffff
[   62.257106]   PREFETCH window: f8000000-f80fffff
[   62.257219] PCI: Bridge: 0000:00:07.0
[   62.257323]   IO window: 5000-5fff
[   62.257428]   MEM window: f7d00000-f7dfffff
[   62.257535]   PREFETCH window: f8100000-f81fffff
[   62.257664] PCI: Bridge: 0000:00:08.0
[   62.257767]   IO window: disabled.
[   62.257872]   MEM window: f7e00000-f7efffff
[   62.257979]   PREFETCH window: disabled.
[   62.258131] PCI: Bridge: 0000:04:09.0
[   62.258235]   IO window: 6000-6fff
[   62.258340]   MEM window: f7f00000-f7ffffff
[   62.258448]   PREFETCH window: f8200000-f82fffff
[   62.258557] PCI: Bridge: 0000:04:0a.0
[   62.258678]   IO window: disabled.
[   62.258783]   MEM window: disabled.
[   62.258887]   PREFETCH window: disabled.
[   62.259225] NET: Registered protocol family 2
[   62.295814] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[   62.297336] TCP established hash table entries: 65536 (order: 10, 419430=
4 bytes)
[   62.308707] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[   62.316827] TCP: Hash tables configured (established 65536 bind 65536)
[   62.316969] TCP reno registered
[   62.378385] audit: initializing netlink socket (disabled)
[   62.378554] audit(1172669747.284:1): initialized
[   62.378908] Total HugeTLB memory allocated, 0
[   62.379768] VFS: Disk quotas dquot_6.5.1
[   62.379919] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   62.380569] SGI XFS with large block/inode numbers, no debug enabled
[   62.381983] io scheduler noop registered
[   62.382148] io scheduler anticipatory registered
[   62.382315] io scheduler deadline registered
[   62.382557] io scheduler cfq registered (default)
[   62.417265] input: Power Button (FF) as /class/input/input0
[   62.417388] ACPI: Power Button (FF) [PWRF]
[   62.428417] Generic RTC Driver v1.07
[   62.428717] AMD768 RNG detected
[   62.429097] Linux agpgart interface v0.102 (c) Dave Jones
[   62.429209] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[   62.429733] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   62.433509] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[   62.434909] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   62.438010] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024=
 blocksize
[   62.438161] HP CISS Driver (v 3.6.14)
[   62.438623] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 24 (level, low) -=
> IRQ 24
[   62.519482] cciss0: <0x46> at PCI 0000:02:04.0 IRQ 24 using DAC
[   62.535450]       blocks=3D 142253280 block_size=3D 512
[   62.543443]       heads=3D255, sectors=3D32, cylinders=3D17433
[   62.543445]=20
[   62.551435]       blocks=3D 142253280 block_size=3D 512
[   62.559430]       heads=3D255, sectors=3D32, cylinders=3D17433
[   62.559431]=20
[   62.561641]       blocks=3D 142253280 block_size=3D 512
[   62.561837]       heads=3D255, sectors=3D32, cylinders=3D17433
[   62.561838]=20
[   62.562089]  cciss/c0d0: p1 p2 p3
[   62.572705]       blocks=3D 142253280 block_size=3D 512
[   62.572908]       heads=3D255, sectors=3D32, cylinders=3D17433
[   62.572909]=20
[   62.573131]  cciss/c0d1: p1 p2 p3
[   62.580161] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   62.580279] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   62.580511] AMD8111: IDE controller at PCI slot 0000:00:04.1
[   62.580636] AMD8111: chipset revision 3
[   62.580740] AMD8111: not 100% native mode: will probe irqs later
[   62.580861] AMD8111: 0000:00:04.1 (rev 03) UDMA133 controller
[   62.580981]     ide0: BM-DMA at 0x2000-0x2007, BIOS settings: hda:pio, h=
db:pio
[   62.581253] Probing IDE interface ide0...
[   63.374939] hda: TSSTcorpCD-ROM TS-L162C, ATAPI CD/DVD-ROM drive
[   64.051365] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   64.054275] hda: ATAPI 24X CD-ROM drive, 96kB Cache, UDMA(33)
[   64.054742] Uniform CD-ROM driver Revision: 3.20
[   64.059130] Loading iSCSI transport class v2.0-724.
[   64.059576] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[   64.059745] ACPI: PCI Interrupt 0000:01:00.0[D] -> GSI 19 (level, low) -=
> IRQ 19
[   64.059977] ohci_hcd 0000:01:00.0: OHCI Host Controller
[   64.060598] ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus =
number 1
[   64.060776] ohci_hcd 0000:01:00.0: irq 19, io mem 0xf7cf0000
[   64.120747] usb usb1: configuration #1 chosen from 1 choice
[   64.121075] hub 1-0:1.0: USB hub found
[   64.121216] hub 1-0:1.0: 3 ports detected
[   64.226637] ACPI: PCI Interrupt 0000:01:00.1[D] -> GSI 19 (level, low) -=
> IRQ 19
[   64.226866] ohci_hcd 0000:01:00.1: OHCI Host Controller
[   64.227141] ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus =
number 2
[   64.227310] ohci_hcd 0000:01:00.1: irq 19, io mem 0xf7ce0000
[   64.288399] usb usb2: configuration #1 chosen from 1 choice
[   64.288670] hub 2-0:1.0: USB hub found
[   64.288787] hub 2-0:1.0: 3 ports detected
[   64.394428] usbcore: registered new interface driver hiddev
[   64.394672] usbcore: registered new interface driver usbhid
[   64.394786] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   64.395187] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64=
 irq 1,12
[   64.397164] serio: i8042 KBD port at 0x60,0x64 irq 1
[   64.397331] serio: i8042 AUX port at 0x60,0x64 irq 12
[   64.397800] mice: PS/2 mouse device common for all mice
[   64.439516] input: AT Translated Set 2 keyboard as /class/input/input1
[   64.444884] md: raid0 personality registered for level 0
[   64.444996] md: raid1 personality registered for level 1
[   64.445400] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:=
 dm-devel@redhat.com
[   64.446079] TCP cubic registered
[   64.446220] NET: Registered protocol family 1
[   64.446758] Freeing unused kernel memory: 1560k freed
[   64.448226] Write protecting the kernel read-only data: 1157k
[   64.450003] Time: acpi_pm clocksource has been installed.
[   64.500964] md: md0 stopped.
[   64.544656] md: bind<cciss/c0d1p1>
[   64.545204] md: bind<cciss/c0d0p1>
[   64.545949] raid1: raid set md0 active with 2 out of 2 mirrors
[   64.548036] md: md1 stopped.
[   64.579344] md: bind<cciss/c0d1p2>
[   64.579803] md: bind<cciss/c0d0p2>
[   64.580367] raid1: raid set md1 active with 2 out of 2 mirrors
[   64.582393] md: md2 stopped.
[   64.598875] md: bind<cciss/c0d1p3>
[   64.599325] md: bind<cciss/c0d0p3>
[   64.599892] raid1: raid set md2 active with 2 out of 2 mirrors
[   64.625046] kjournald starting.  Commit interval 5 seconds
[   64.625155] EXT3-fs: mounted filesystem with ordered data mode.
[   68.318788] tg3.c:v3.74 (February 20, 2007)
[   68.318969] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 28 (level, low) -=
> IRQ 28
[   68.366156] eth0: Tigon3 [partno(N/A) rev 2100 PHY(5704)] (PCIX:133MHz:6=
4-bit) 10/100/1000Base-T Ethernet 00:18:71:e4:5e:8a
[   68.366669] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] Wire=
Speed[1] TSOcap[0]=20
[   68.366824] eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[   68.366995] ACPI: PCI Interrupt 0000:03:06.1[B] -> GSI 29 (level, low) -=
> IRQ 29
[   68.414189] eth1: Tigon3 [partno(N/A) rev 2100 PHY(5704)] (PCIX:133MHz:6=
4-bit) 10/100/1000Base-T Ethernet 00:18:71:e4:5e:89
[   68.414704] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] Wire=
Speed[1] TSOcap[1]=20
[   68.414860] eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[   68.572438] QLogic Fibre Channel HBA Driver
[   68.572724] ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 32 (level, low) -=
> IRQ 32
[   68.573262] qla2xxx 0000:05:08.0: Found an ISP2422, irq 32, iobase 0xfff=
fc20000022000
[   68.573716] qla2xxx 0000:05:08.0: Configuring PCI space...
[   68.576054] qla2xxx 0000:05:08.0: Configure NVRAM parameters...
[   68.582688] qla2xxx 0000:05:08.0: Verifying loaded RISC code...
[   68.666290] PM: Writing back config space on device 0000:03:06.1 at offs=
et b (was 164814e4, writing d00e11)
[   68.666307] PM: Writing back config space on device 0000:03:06.1 at offs=
et 3 (was 804000, writing 804010)
[   68.666312] PM: Writing back config space on device 0000:03:06.1 at offs=
et 2 (was 2000000, writing 2000010)
[   68.666318] PM: Writing back config space on device 0000:03:06.1 at offs=
et 1 (was 2b00000, writing 2b00146)
[   68.848753] Adding 6540152k swap on /dev/md2.  Priority:-1 extents:1 acr=
oss:6540152k
[   68.918029] qla2xxx 0000:05:08.0: Allocated (64 KB) for EFT...
[   68.918352] qla2xxx 0000:05:08.0: Allocated (1413 KB) for firmware dump.=
=2E.
[   68.938105] scsi0 : qla2xxx
[   69.029240] EXT3 FS on md1, internal journal
[   69.071784] qla2xxx 0000:05:08.0:=20
[   69.071785]  QLogic Fibre Channel HBA Driver: 8.01.07-k5
[   69.071786]   QLogic HP AE369-60001 - QLA2340
[   69.071787]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.0 hdma+, host=
#=3D0, fw=3D4.00.27 [IP]=20
[   69.072317] ACPI: PCI Interrupt 0000:05:08.1[B] -> GSI 33 (level, low) -=
> IRQ 33
[   69.072671] qla2xxx 0000:05:08.1: Found an ISP2422, irq 33, iobase 0xfff=
fc20000028000
[   69.073179] qla2xxx 0000:05:08.1: Configuring PCI space...
[   69.075480] qla2xxx 0000:05:08.1: Configure NVRAM parameters...
[   69.082057] qla2xxx 0000:05:08.1: Verifying loaded RISC code...
[   69.425615] qla2xxx 0000:05:08.1: Allocated (64 KB) for EFT...
[   69.425949] qla2xxx 0000:05:08.1: Allocated (1413 KB) for firmware dump.=
=2E.
[   69.445950] scsi1 : qla2xxx
[   69.570607] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[   69.570627] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[   69.570634] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[   69.570641] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[   69.595597] qla2xxx 0000:05:08.1:=20
[   69.595599]  QLogic Fibre Channel HBA Driver: 8.01.07-k5
[   69.595600]   QLogic HP AE369-60001 - QLA2340
[   69.595601]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.1 hdma+, host=
#=3D1, fw=3D4.00.27 [IP]=20
[   69.761182] qla2xxx 0000:05:08.0: LIP reset occured (f8f7).
[   69.796520] qla2xxx 0000:05:08.0: LIP occured (f8f7).
[   69.798698] qla2xxx 0000:05:08.0: LOOP UP detected (2 Gbps).
[   69.940110] scsi 0:0:0:0: Direct-Access     transtec T6100F16R1-E     34=
2I PQ: 0 ANSI: 5
[   69.940785] sda : very big device. try to use READ CAPACITY(16).
[   69.940999] SCSI device sda: 11714863104 512-byte hdwr sectors (5998010 =
MB)
[   69.941386] sda: Write Protect is off
[   69.941491] sda: Mode Sense: 9b 00 00 08
[   69.941794] SCSI device sda: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   69.942531] sda : very big device. try to use READ CAPACITY(16).
[   69.942737] SCSI device sda: 11714863104 512-byte hdwr sectors (5998010 =
MB)
[   69.943093] sda: Write Protect is off
[   69.943198] sda: Mode Sense: 9b 00 00 08
[   69.943483] SCSI device sda: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   69.943665]  sda: unknown partition table
[   69.944175] sd 0:0:0:0: Attached scsi disk sda
[   69.944491] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   70.206428] qla2xxx 0000:05:08.1: LIP reset occured (f7f7).
[   70.241834] qla2xxx 0000:05:08.1: LIP occured (f7f7).
[   70.244010] qla2xxx 0000:05:08.1: LOOP UP detected (2 Gbps).
[   70.447043] scsi 1:0:0:0: Direct-Access     ADVUNI   OXYGENRAID 416F  34=
1B PQ: 0 ANSI: 3
[   70.447653] sdb : very big device. try to use READ CAPACITY(16).
[   70.447918] SCSI device sdb: 9370656768 512-byte hdwr sectors (4797776 M=
B)
[   70.448369] sdb: Write Protect is off
[   70.448475] sdb: Mode Sense: 8f 00 00 08
[   70.448939] SCSI device sdb: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   70.449468] sdb : very big device. try to use READ CAPACITY(16).
[   70.449737] SCSI device sdb: 9370656768 512-byte hdwr sectors (4797776 M=
B)
[   70.450175] sdb: Write Protect is off
[   70.450282] sdb: Mode Sense: 8f 00 00 08
[   70.450738] SCSI device sdb: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   70.450919]  sdb: unknown partition table
[   70.451546] sd 1:0:0:0: Attached scsi disk sdb
[   70.451809] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   70.494620] hda: packet command error: status=3D0x51 { DriveReady SeekCo=
mplete Error }
[   70.496805] hda: packet command error: error=3D0x54 { AbortedCommand Las=
tFailedSense=3D0x05 }
[   70.497134] ide: failed opcode was: unknown
[   71.057732] NET: Registered protocol family 17
[   71.274301] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.274461] device-mapper: ioctl: error adding target to table
[   71.275795] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.275948] device-mapper: ioctl: error adding target to table
[   71.277527] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.277718] device-mapper: ioctl: error adding target to table
[   71.279141] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.279332] device-mapper: ioctl: error adding target to table
[   71.280791] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.280980] device-mapper: ioctl: error adding target to table
[   71.282711] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.282902] device-mapper: ioctl: error adding target to table
[   71.284376] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.284574] device-mapper: ioctl: error adding target to table
[   71.285940] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.286131] device-mapper: ioctl: error adding target to table
[   71.287512] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.287703] device-mapper: ioctl: error adding target to table
[   71.289147] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.289336] device-mapper: ioctl: error adding target to table
[   71.290811] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.291002] device-mapper: ioctl: error adding target to table
[   71.292474] device-mapper: table: 238:8: linear: dm-linear: Device looku=
p failed
[   71.292671] device-mapper: ioctl: error adding target to table
[   72.122418] tg3: eth2: Link is up at 1000 Mbps, full duplex.
[   72.122538] tg3: eth2: Flow control is on for TX and on for RX.
[   72.220661] tg3: eth3: Link is up at 1000 Mbps, full duplex.
[   72.220779] tg3: eth3: Flow control is off for TX and off for RX.
[   73.447400] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   73.486247] kjournald starting.  Commit interval 5 seconds
[   73.503340] EXT3 FS on md0, internal journal
[   73.503519] EXT3-fs: mounted filesystem with ordered data mode.
[   77.025062] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   77.034331] NFSD: starting 90-second grace period
[  712.188710]=20
[  712.188713] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  712.188927] [ INFO: possible recursive locking detected ]
[  712.189041] 2.6.21-rc2 #39
[  712.189142] ---------------------------------------------
[  712.189257] lvs/6073 is trying to acquire lock:
[  712.189368]  (&md->io_lock){----}, at: [<ffffffff8049de65>] dm_request+0=
x25/0x150
[  712.189771]=20
[  712.189772] but task is already holding lock:
[  712.189977]  (&md->io_lock){----}, at: [<ffffffff8049de65>] dm_request+0=
x25/0x150
[  712.190374]=20
[  712.190374] other info that might help us debug this:
[  712.190583] 1 lock held by lvs/6073:
[  712.190708]  #0:  (&md->io_lock){----}, at: [<ffffffff8049de65>] dm_requ=
est+0x25/0x150
[  712.191230]=20
[  712.191231] stack backtrace:
[  712.191467]=20
[  712.191468] Call Trace:
[  712.191712]  [<ffffffff8024aa49>] __lock_acquire+0xae9/0xfa0
[  712.191855]  [<ffffffff80264bb1>] mempool_alloc_slab+0x11/0x20
[  712.191999]  [<ffffffff8028997c>] kmem_cache_alloc+0x11c/0x140
[  712.192142]  [<ffffffff8049de65>] dm_request+0x25/0x150
[  712.192283]  [<ffffffff8024b2cb>] lock_acquire+0x8b/0xc0
[  712.192423]  [<ffffffff8049de65>] dm_request+0x25/0x150
[  712.192561]  [<ffffffff80245109>] down_read+0x39/0x50
[  712.192698]  [<ffffffff8049de65>] dm_request+0x25/0x150
[  712.192837]  [<ffffffff8039ba9e>] generic_make_request+0x17e/0x1a0
[  712.192983]  [<ffffffff8049cd2c>] __map_bio+0x4c/0xb0
[  712.193119]  [<ffffffff8049d5ff>] __split_bio+0x16f/0x3e0
[  712.193261]  [<ffffffff8049df70>] dm_request+0x130/0x150
[  712.193401]  [<ffffffff8039ba9e>] generic_make_request+0x17e/0x1a0
[  712.193547]  [<ffffffff802b9d90>] dio_bio_submit+0x40/0xa0
[  712.193690]  [<ffffffff8039df92>] submit_bio+0xd2/0xe0
[  712.193826]  [<ffffffff802b9dc8>] dio_bio_submit+0x78/0xa0
[  712.193969]  [<ffffffff802bafa8>] __blockdev_direct_IO+0x958/0xbd0
[  712.194112]  [<ffffffff8024ae4f>] __lock_acquire+0xeef/0xfa0
[  712.194252]  [<ffffffff802b9b19>] blkdev_direct_IO+0x49/0x50
[  712.194392]  [<ffffffff802b9a20>] blkdev_get_blocks+0x0/0xb0
[  712.194531]  [<ffffffff802628ad>] generic_file_direct_IO+0xad/0x120
[  712.194675]  [<ffffffff80264223>] generic_file_aio_read+0xd3/0x1d0
[  712.194818]  [<ffffffff8024ae4f>] __lock_acquire+0xeef/0xfa0
[  712.194963]  [<ffffffff8028fd19>] do_sync_read+0xe9/0x140
[  712.195102]  [<ffffffff8024b5b1>] trace_hardirqs_on+0x141/0x180
[  712.195244]  [<ffffffff80241ee0>] autoremove_wake_function+0x0/0x40
[  712.195390]  [<ffffffff8024b5b1>] trace_hardirqs_on+0x141/0x180
[  712.195536]  [<ffffffff8029014b>] vfs_read+0xbb/0x160
[  712.195674]  [<ffffffff80290ae0>] sys_read+0x50/0x90
[  712.195813]  [<ffffffff80209a7e>] system_call+0x7e/0x83
[  712.195950]=20

--=20
The only person who always got his work done by Friday was Robinson Crusoe

--cf0hFtnykp6aONGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF5b+zWto1QDEAkw8RAqihAKCiej9l7QQ+VWJYfEnbF7GzXV+QcwCfXgT5
0cl6rBuOcQiex+nKYkhbFc8=
=nVkE
-----END PGP SIGNATURE-----

--cf0hFtnykp6aONGL--


--===============1131891656==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1131891656==--
