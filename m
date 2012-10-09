From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: linux-next oops
Date: Tue, 09 Oct 2012 11:30:03 -0400
Message-ID: <20121009153003.92EA7801A1@viridian.itc.virginia.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="%--multipart-mixed-boundary-1.20210.1349796603--%"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids


--%--multipart-mixed-boundary-1.20210.1349796603--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

I'm seeing an oops with the patch
http://people.redhat.com/agk/patches/linux/editing/dm-store-dm_target_io-in-bio-front_pad.patch
in linux-next (commit 24d047b).

I'll attach the dmesg output from a crash.  I bisected it down to this
one patch and verified that reverting it results in a kernel that
boots normally.  It appears that this will crash any linux-next kernel
since 20120918 -- I've not tried them all, but I have tried a few.

The machines where this happens are Dell PowerEdge SC1425

-- 
Bill



--%--multipart-mixed-boundary-1.20210.1349796603--%
Content-Type: application/octet-stream
Content-Transfer-Encoding: 7bit
Content-Description: ASCII text
Content-Disposition: attachment; filename="dmesg.crash"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-next-20121009 (wfp5p@viridian.itc.virginia.edu) (gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC) ) #19 SMP Tue Oct 9 09:59:35 EDT 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.6.0-next-20121009 root=/dev/mapper/rootvg-hd4 ro rd.md=0 rd.dm=0 KEYTABLE=us SYSFONT=True rd.lvm.lv=rootvg/paging0 rd.luks=0 rd.lvm.lv=rootvg/hd4 LANG=en_US.UTF-8 console=ttyS0,115200
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffbffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffc0000-0x00000000bffcfbff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bffcfc00-0x00000000bfffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xbffc0 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped at [ffff8800000fe710]
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbffbffff]
[    0.000000] RAMDISK: [mem 0x36ca0000-0x37647fff]
[    0.000000] ACPI: RSDP 00000000000fd650 00014 (v00 DELL  )
[    0.000000] ACPI: RSDT 00000000000fd664 00038 (v01 DELL   PESC1425 00000001 MSFT 0100000A)
[    0.000000] ACPI: FACP 00000000000fd6b0 00074 (v01 DELL   PESC1425 00000001 MSFT 0100000A)
[    0.000000] ACPI: DSDT 00000000bffc0000 0174C (v01 DELL   PESC1425 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000bffcfc00 00040
[    0.000000] ACPI: APIC 00000000000fd724 0009C (v01 DELL   PESC1425 00000001 MSFT 0100000A)
[    0.000000] ACPI: SPCR 00000000000fd7c0 00050 (v01 DELL   PESC1425 00000001 MSFT 0100000A)
[    0.000000] ACPI: HPET 00000000000fd810 00038 (v01 DELL   PESC1425 00000001 MSFT 0100000A)
[    0.000000] ACPI: MCFG 00000000000fd848 0003C (v01 DELL   PESC1425 00000001 MSFT 0100000A)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000bffbffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xbffbffff]
[    0.000000]   NODE_DATA [mem 0xbffab000-0xbffbffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xbffbffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 7, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec80000] gsi_base[32])
[    0.000000] IOAPIC[1]: apic_id 8, version 32, address 0xfec80000, GSI 32-55
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80800] gsi_base[64])
[    0.000000] IOAPIC[2]: apic_id 9, version 32, address 0xfec80800, GSI 64-87
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] e820: [mem 0xbffff000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8800bfc00000 s87232 r8192 d23360 u524288
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 773962
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.6.0-next-20121009 root=/dev/mapper/rootvg-hd4 ro rd.md=0 rd.dm=0 KEYTABLE=us SYSFONT=True rd.lvm.lv=rootvg/paging0 rd.luks=0 rd.lvm.lv=rootvg/hd4 LANG=en_US.UTF-8 console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3061928k/3145472k available (6327k kernel code, 448k absent, 83096k reserved, 6954k data, 1032k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3000.157 MHz processor
[    0.002005] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.31 BogoMIPS (lpj=3000157)
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.005087] Security Framework initialized
[    0.006017] SELinux:  Initializing.
[    0.007678] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.010793] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013134] Mount-cache hash table entries: 256
[    0.015518] Initializing cgroup subsys cpuacct
[    0.016006] Initializing cgroup subsys devices
[    0.017003] Initializing cgroup subsys freezer
[    0.018003] Initializing cgroup subsys blkio
[    0.019003] Initializing cgroup subsys perf_event
[    0.020084] CPU0: Hyper-Threading is disabled
[    0.021004] mce: CPU supports 4 MCE banks
[    0.022015] CPU0: Thermal monitoring enabled (TM1)
[    0.023006] process: using mwait in idle threads
[    0.024007] Last level iTLB entries: 4KB 128, 2MB 128, 4MB 128
[    0.024007] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 64
[    0.024007] tlb_flushall_shift: 6
[    0.025175] Freeing SMP alternatives: 20k freed
[    0.027364] ACPI: Core revision 20120913
[    0.030013] ftrace: allocating 22966 entries in 90 pages
[    0.040802] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.051019] smpboot: CPU0: Intel(R) Xeon(TM) CPU 3.00GHz (fam: 0f, model: 04, stepping: 03)
[    0.055991] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.058002] ... version:                0
[    0.058994] ... bit width:              40
[    0.059993] ... generic registers:      18
[    0.060993] ... value mask:             000000ffffffffff
[    0.061993] ... max period:             0000007fffffffff
[    0.062993] ... fixed-purpose events:   0
[    0.063993] ... event mask:             000000000003ffff
[    0.067808] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.069088] SMP alternatives: lockdep: fixing up alternatives
[    0.070003] smpboot: Booting Node   0, Processors  #1
[    0.143025] Brought up 2 CPUs
[    0.143983] smpboot: Total of 2 processors activated (12000.56 BogoMIPS)
[    0.147259] devtmpfs: initialized
[    0.150806] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.151016] RTC time: 15:12:18, date: 10/09/12
[    0.152127] NET: Registered protocol family 16
[    0.154251] ACPI: bus type pci registered
[    0.155095] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.155980] PCI: Intel Corporation E7520 Memory Controller Hub with MMCONFIG support
[    0.156986] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.187383] PCI: Using configuration type 1 for base access
[    0.189187] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.189974] mtrr: probably your BIOS does not setup all CPUs.
[    0.190973] mtrr: corrected configuration.
[    0.194754] bio: create slab <bio-0> at 0
[    0.196091] ACPI: Added _OSI(Module Device)
[    0.196975] ACPI: Added _OSI(Processor Device)
[    0.197974] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.198974] ACPI: Added _OSI(Processor Aggregator Device)
[    0.205529] ACPI: Interpreter enabled
[    0.205977] ACPI: (supports S0 S4 S5)
[    0.207840] ACPI: Using IOAPIC for interrupt routing
[    0.215784] ACPI: No dock devices found.
[    0.215976] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.217603] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.219425] PCI host bridge to bus 0000:00
[    0.219974] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.220971] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.221971] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.224521] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.225140] pci 0000:01:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.226099] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.226988] pci 0000:00:02.0: PCI bridge to [bus 01-03]
[    0.229116] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.230092] pci 0000:01:00.2: PCI bridge to [bus 03]
[    0.231417] pci 0000:00:1e.0: PCI bridge to [bus 04] (subtractive decode)
[    0.233064]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.233969]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.237582] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12) *15
[    0.240624] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12)
[    0.243361] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12)
[    0.246255] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12) *14
[    0.250256] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 *6 7 10 11 12)
[    0.254061] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.259062] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    0.264060] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12)
[    0.268098] vgaarb: device added: PCI:0000:04:0d.0,decodes=io+mem,owns=io+mem,locks=none
[    0.268964] vgaarb: loaded
[    0.269962] vgaarb: bridge control possible 0000:04:0d.0
[    0.271093] SCSI subsystem initialized
[    0.271967] ACPI: bus type scsi registered
[    0.273081] ACPI: bus type usb registered
[    0.274008] usbcore: registered new interface driver usbfs
[    0.274987] usbcore: registered new interface driver hub
[    0.275994] usbcore: registered new device driver usb
[    0.277086] PCI: Using ACPI for IRQ routing
[    0.289336] NetLabel: Initializing
[    0.289960] NetLabel:  domain hash size = 128
[    0.290958] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.292007] NetLabel:  unlabeled traffic allowed by default
[    0.293058] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.293962] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.296708] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.299082] Switching to clocksource hpet
[    0.332980] pnp: PnP ACPI init
[    0.336093] ACPI: bus type pnp registered
[    0.344318] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.350250] system 00:08: [io  0x0880-0x08bf] has been reserved
[    0.356173] system 00:08: [io  0x08c0-0x08df] has been reserved
[    0.362099] system 00:08: [io  0x08e0-0x08e3] has been reserved
[    0.368026] system 00:08: [io  0x0c00-0x0c0f] has been reserved
[    0.373951] system 00:08: [io  0x0c10-0x0c1f] has been reserved
[    0.379875] system 00:08: [io  0x0ca0-0x0ca7] has been reserved
[    0.385800] system 00:08: [io  0x0ca9-0x0cab] has been reserved
[    0.391728] system 00:08: [io  0x0cad-0x0caf] has been reserved
[    0.397652] system 00:08: [io  0x0c20-0x0c3f] has been reserved
[    0.403882] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.410911] pnp: PnP ACPI: found 12 devices
[    0.415099] ACPI: ACPI bus type pnp unregistered
[    0.431433] pci 0000:00:1f.1: BAR 5: assigned [mem 0xc0000000-0xc00003ff]
[    0.438229] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.443204] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.449306] pci 0000:01:00.0:   bridge window [mem 0xfe900000-0xfeafffff]
[    0.456102] pci 0000:01:00.2: PCI bridge to [bus 03]
[    0.461087] pci 0000:00:02.0: PCI bridge to [bus 01-03]
[    0.466316] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.472417] pci 0000:00:02.0:   bridge window [mem 0xfe700000-0xfeafffff]
[    0.479218] pci 0000:04:0d.0: BAR 6: assigned [mem 0xfe500000-0xfe51ffff pref]
[    0.486440] pci 0000:00:1e.0: PCI bridge to [bus 04]
[    0.491625] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.497723] pci 0000:00:1e.0:   bridge window [mem 0xfe500000-0xfe6fffff]
[    0.504515] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
[    0.511907] NET: Registered protocol family 2
[    0.517609] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.530189] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    0.541343] TCP: Hash tables configured (established 524288 bind 65536)
[    0.548148] TCP: reno registered
[    0.551450] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.557865] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.564862] NET: Registered protocol family 1
[    0.569441] pci 0000:01:00.0: rerouting interrupts for [8086:0329]
[    0.575633] pci 0000:01:00.2: rerouting interrupts for [8086:032a]
[    0.582026] Unpacking initramfs...
[    0.883901] Freeing initrd memory: 9888k freed
[    0.896427] audit: initializing netlink socket (disabled)
[    0.901944] type=2000 audit(1349795537.900:1): initialized
[    0.935067] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.946068] VFS: Disk quotas dquot_6.5.2
[    0.950116] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.957762] msgmni has been set to 5999
[    0.963107] alg: No test for stdrng (krng)
[    0.967236] NET: Registered protocol family 38
[    0.971795] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.979322] io scheduler noop registered
[    0.983258] io scheduler deadline registered
[    0.987667] io scheduler cfq registered (default)
[    0.992763] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.998429] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.005049] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.012399] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.019822] ACPI: Power Button [PWRF]
[    1.028757] GHES: HEST is not enabled!
[    1.032692] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.039205] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    1.045969] Non-volatile memory driver v1.3
[    1.052246] loop: module loaded
[    1.055599] ata_piix 0000:00:1f.1: enabling device (0000 -> 0003)
[    1.062551] scsi0 : ata_piix
[    1.065675] scsi1 : ata_piix
[    1.068665] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    1.075629] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    1.082626] ata_piix 0000:00:1f.2: MAP [
[    1.086565]  P0 -- P1 -- ]
[    1.240664] scsi2 : ata_piix
[    1.243724] scsi3 : ata_piix
[    1.246715] ata3: SATA max UDMA/133 cmd 0xccb8 ctl 0xccb0 bmdma 0xcc80 irq 18
[    1.253857] ata4: SATA max UDMA/133 cmd 0xcca0 ctl 0xcc98 bmdma 0xcc88 irq 18
[    1.261192] libphy: Fixed MDIO Bus: probed
[    1.265475] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.272075] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.277446] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.288835] ehci_hcd 0000:00:1d.7: debug port 1
[    1.293417] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfeb00000
[    1.305032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.310947] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.317738] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.324962] usb usb1: Product: EHCI Host Controller
[    1.329847] usb usb1: Manufacturer: Linux 3.6.0-next-20121009 ehci_hcd
[    1.336373] usb usb1: SerialNumber: 0000:00:1d.7
[    1.341334] hub 1-0:1.0: USB hub found
[    1.345100] hub 1-0:1.0: 4 ports detected
[    1.349465] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.355691] uhci_hcd: USB Universal Host Controller Interface driver
[    1.362109] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.367433] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.374844] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.379783] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000cce0
[    1.385635] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.392428] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.399653] usb usb2: Product: UHCI Host Controller
[    1.404537] usb usb2: Manufacturer: Linux 3.6.0-next-20121009 uhci_hcd
[    1.411070] usb usb2: SerialNumber: 0000:00:1d.0
[    1.415950] hub 2-0:1.0: USB hub found
[    1.419717] hub 2-0:1.0: 2 ports detected
[    1.423967] ata3.00: ATA-7: WDC WD400BD-75MRA2, 10.01E03, max UDMA/133
[    1.424032] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.424153] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.424161] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.424212] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ccc0
[    1.424290] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.424292] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.424294] usb usb3: Product: UHCI Host Controller
[    1.424296] usb usb3: Manufacturer: Linux 3.6.0-next-20121009 uhci_hcd
[    1.424298] usb usb3: SerialNumber: 0000:00:1d.1
[    1.424535] hub 3-0:1.0: USB hub found
[    1.424543] hub 3-0:1.0: 2 ports detected
[    1.424862] usbcore: registered new interface driver usbserial
[    1.424886] usbcore: registered new interface driver usbserial_generic
[    1.424921] usbserial: USB Serial support registered for generic
[    1.425001] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.427798] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.427823] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.428146] mousedev: PS/2 mouse device common for all mice
[    1.461825] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.541918] ata3.00: 78125000 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    1.542124] rtc_cmos 00:04: RTC can wake from S4
[    1.542462] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.542497] rtc0: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
[    1.542785] device-mapper: uevent: version 1.0.3
[    1.542963] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    1.543161] cpuidle: using governor ladder
[    1.543163] cpuidle: using governor menu
[    1.543961] EFI Variables Facility v0.08 2004-May-17
[    1.544252] usbcore: registered new interface driver usbhid
[    1.544253] usbhid: USB HID core driver
[    1.544290] drop_monitor: Initializing network drop monitor service
[    1.544489] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.612779] TCP: cubic registered
[    1.615550] ata3.00: configured for UDMA/133
[    1.620376] Initializing XFRM netlink socket
[    1.620684] scsi 2:0:0:0: Direct-Access     ATA      WDC WD400BD-75MR 10.0 PQ: 0 ANSI: 5
[    1.621175] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.621406] sd 2:0:0:0: [sda] 78125000 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    1.621540] sd 2:0:0:0: [sda] Write Protect is off
[    1.621599] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.642867]  sda: sda1 sda2
[    1.643538] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.667167] NET: Registered protocol family 10
[    1.672133] mip6: Mobile IPv6
[    1.675113] NET: Registered protocol family 17
[    1.679669] Key type dns_resolver registered
[    1.684688] registered taskstats version 1
[    1.689488]   Magic number: 0:459:234
[    1.693262] rtc_cmos 00:04: setting system clock to 2012-10-09 15:12:20 UTC (1349795540)
[    1.701497] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[    1.711116] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[    1.720689] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[    1.730582] Freeing unused kernel memory: 1032k freed
[    1.736267] Write protecting the kernel read-only data: 12288k
[    1.749944] Freeing unused kernel memory: 1852k freed
[    1.761612] Freeing unused kernel memory: 1396k freed
[    1.859909] dracut: dracut-018-98.git20120813.fc17
[    1.896118] tsc: Refined TSC clocksource calibration: 3000.106 MHz
[    1.902326] Switching to clocksource tsc
[    1.942532] udevd[107]: starting version 182
[    1.992795] Linux agpgart interface v0.103
[    2.015233] [drm] Initialized drm 1.1.0 20060810
[    2.047758] [drm] radeon defaulting to kernel modesetting.
[    2.053263] [drm] radeon kernel modesetting enabled.
[    2.059211] [drm] initializing kernel modesetting (RV100 0x1002:0x5159 0x1028:0x019A).
[    2.067158] [drm] register mmio base: 0xFE5D0000
[    2.071776] [drm] register mmio size: 65536
[    2.076145] radeon 0000:04:0d.0: VRAM: 128M 0x00000000F0000000 - 0x00000000F7FFFFFF (16M used)
[    2.084760] radeon 0000:04:0d.0: GTT: 512M 0x00000000D0000000 - 0x00000000EFFFFFFF
[    2.092344] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.098952] [drm] Driver supports precise vblank timestamp query.
[    2.105107] [drm] radeon: irq initialized.
[    2.110767] [drm] Detected VRAM RAM=128M, BAR=128M
[    2.115566] [drm] RAM width 32bits DDR
[    2.119524] [TTM] Zone  kernel: Available graphics memory: 1538058 kiB
[    2.126056] [TTM] Initializing pool allocator
[    2.130429] [TTM] Initializing DMA pool allocator
[    2.135382] [drm] radeon: 16M of VRAM memory ready
[    2.140176] [drm] radeon: 512M of GTT memory ready.
[    2.145121] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.173449] [drm] PCI GART of 512M enabled (table at 0x0000000036C00000).
[    2.180317] radeon 0000:04:0d.0: WB disabled
[    2.184600] radeon 0000:04:0d.0: fence driver on ring 0 use gpu addr 0x00000000d0000000 and cpu addr 0xffff880036d64000
[    2.195884] [drm] Loading R100 Microcode
[    2.200359] [drm] radeon: ring at 0x00000000D0001000
[    2.205492] [drm] ring test succeeded in 1 usecs
[    2.210516] [drm] ib test succeeded in 0 usecs
[    2.215964] [drm] Radeon Display Connectors
[    2.220163] [drm] Connector 0:
[    2.223231] [drm]   VGA-1
[    2.225864] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    2.231874] [drm]   Encoders:
[    2.234844] [drm]     CRT1: INTERNAL_DAC1
[    2.238856] [drm] Connector 1:
[    2.241915] [drm]   VGA-2
[    2.244540] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[    2.250542] [drm]   Encoders:
[    2.253514] [drm]     CRT2: INTERNAL_DAC2
[    2.257526] [drm] Connector 2:
[    2.260585] [drm]   DVI-I-1
[    2.263381] [drm]   HPD1
[    2.265920] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    2.271924] [drm]   Encoders:
[    2.274897] [drm]     CRT2: INTERNAL_DAC2
[    2.278914] [drm]     DFP1: INTERNAL_TMDS1
[    2.373790] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input2
[    2.375355] [drm] fb mappable at 0xF0040000
[    2.375356] [drm] vram apper at 0xF0000000
[    2.375357] [drm] size 786432
[    2.375358] [drm] fb depth is 8
[    2.375359] [drm]    pitch is 1024
[    2.399677] fbcon: radeondrmfb (fb0) is primary device
[    2.564572] Console: switching to colour frame buffer device 128x48
[    2.578091] fb0: radeondrmfb frame buffer device
[    2.582709] drm: registered panic notifier
[    2.586821] [drm] Initialized radeon 2.24.0 20080528 for 0000:04:0d.0 on minor 0
[    2.601408] dracut: Starting plymouth daemon
GCouldn't open /dev/ttyS0
GCannot open font file True
G[    3.179438] dracut: Scanning devices sda2  for LVM logical volumes rootvg/hd4 rootvg/paging0 rootvg/hd4
[    3.214533] dracut: inactive '/dev/rootvg/lv1' [10.00 GiB] inherit
[    3.221081] dracut: inactive '/dev/rootvg/hd4' [10.00 GiB] inherit
[    3.227512] dracut: inactive '/dev/rootvg/paging0' [2.00 GiB] inherit
[    3.265403] bio: create slab <bio-1> at 1
[    3.904880] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    4.018542] dracut: Checking ext4: /dev/mapper/rootvg-hd4
[    4.024251] dracut: issuing e2fsck -a  /dev/mapper/rootvg-hd4
[    4.054403] ------------[ cut here ]------------
[    4.055336] kernel BUG at drivers/scsi/scsi_lib.c:1180!
[    4.055336] invalid opcode: 0000 [#1] SMP 
[    4.055336] Modules linked in: radeon i2c_algo_bit drm_kms_helper ttm drm agpgart i2c_core
[    4.055336] CPU 0 
[    4.055336] Pid: 265, comm: e2fsck Not tainted 3.6.0-next-20121009 #19 Dell Computer Corporation PowerEdge SC1425/0D7449
[    4.055336] RIP: 0010:[<ffffffff813e3732>]  [<ffffffff813e3732>] scsi_setup_fs_cmnd+0x92/0xa0
[    4.055336] RSP: 0018:ffff880037573be8  EFLAGS: 00010046
[    4.055336] RAX: 0000000000000000 RBX: ffff8800bbb6f000 RCX: 0000000000000002
[    4.055336] RDX: 0000000000000000 RSI: ffff880037710000 RDI: ffff8800bbb6f000
[    4.055336] RBP: ffff880037573bf8 R08: 0000000000000001 R09: 0000000000000000
[    4.055336] R10: ffff8800bbb6f000 R11: ffff880037504590 R12: ffff880037710000
[    4.055336] R13: ffff8800b85c5740 R14: ffff8800b86f9800 R15: 0000000000000000
[    4.055336] FS:  00007f880709a780(0000) GS:ffff8800bfc00000(0000) knlGS:0000000000000000
[    4.055336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.055336] CR2: 00000000011add00 CR3: 00000000374c2000 CR4: 00000000000007f0
[    4.055336] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.055336] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.055336] Process e2fsck (pid: 265, threadinfo ffff880037572000, task ffff880037503f00)
[    4.055336] Stack:
[    4.055336]  ffff880037710000 ffff8800b85c5740 ffff880037573c78 ffffffff813f195f
[    4.055336]  ffff880037573ce8 ffffffff812dcc1a ffffffff812dc99d ffff8800b85c5770
[    4.055336]  ffff880000000000 ffff8800bbb6f000 ffff880037573c48 000000006b6ca5c9
[    4.055336] Call Trace:
[    4.055336]  [<ffffffff813f195f>] sd_prep_fn+0x15f/0xe10
[    4.055336]  [<ffffffff812dcc1a>] ? cfq_insert_request+0x2ca/0x580
[    4.055336]  [<ffffffff812dc99d>] ? cfq_insert_request+0x4d/0x580
[    4.055336]  [<ffffffff812c2720>] blk_peek_request+0x110/0x220
[    4.055336]  [<ffffffff812c2f68>] ? blk_queue_bio+0x2b8/0x3d0
[    4.055336]  [<ffffffff813e3f42>] scsi_request_fn+0x52/0x540
[    4.055336]  [<ffffffff812c2fa2>] blk_queue_bio+0x2f2/0x3d0
[    4.055336]  [<ffffffff814ad123>] ? dm_request+0x33/0x1d0
[    4.055336]  [<ffffffff812c0992>] generic_make_request+0xc2/0x110
[    4.055336]  [<ffffffff812c0a59>] submit_bio+0x79/0x160
[    4.055336]  [<ffffffff811c11c5>] ? bio_alloc_bioset+0x65/0x120
[    4.055336]  [<ffffffff812c497b>] blkdev_issue_flush+0x12b/0x190
[    4.055336]  [<ffffffff811c2a8e>] blkdev_fsync+0x3e/0x50
[    4.055336]  [<ffffffff811ba09d>] do_fsync+0x5d/0x90
[    4.055336]  [<ffffffff812ee299>] ? lockdep_sys_exit_thunk+0x35/0x67
[    4.055336]  [<ffffffff811ba330>] sys_fsync+0x10/0x20
[    4.055336]  [<ffffffff8162a0f9>] system_call_fastpath+0x16/0x1b
[    4.055336] Code: c3 48 8b 00 48 85 c0 74 b7 48 8b 40 48 48 85 c0 74 ae 4c 89 e6 48 89 df ff d0 85 c0 74 a2 eb dc b8 02 00 00 00 0f 1f 40 00 eb d1 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 
[    4.055336] RIP  [<ffffffff813e3732>] scsi_setup_fs_cmnd+0x92/0xa0
[    4.055336]  RSP <ffff880037573be8>
[    4.055336] ---[ end trace 53f9b78ad1a3b47f ]---

--%--multipart-mixed-boundary-1.20210.1349796603--%
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--%--multipart-mixed-boundary-1.20210.1349796603--%--
