From: Charles Slivkoff <slivkoff@cmu.edu>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Wed, 02 Mar 2011 13:52:23 -0500
Message-ID: <4D6E91E7.4010305@cmu.edu>
References: <4D6BFCF9.4080809@cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070203010303090007030108"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D6BFCF9.4080809@cmu.edu>
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070203010303090007030108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Babu. Thanks for responding.

> You said "The array is split into 2 virtual disk, each
> assigned to one of the RAID controllers". Did you mean you
> redistributed the two luns(one is owned by controller A and one by
> controller B)?

Yes. I have assigned 1 LUN to each of the controllers.

> It appears that your luns are moving back and forth between two
> controllers.. You can try setting failback to manual(failback
> manual).  This is not a solution but to understand the problem.

I changed to "failback manual" in /etc/multipath.conf and rebooted. I'm 
not sure if the reboot was necessary or not. This does not appear to 
have changed the behavior.

> Are you seeing "MODE_SELECT" messages in the logs..  Can you paste
> snippet of log messages..

There are no "MODE_SELECT" messages in syslog. Would these be appearing 
elsewhere? The syslog from the last reboot up until I started receiving 
the "Illegal Request" messages is available here http://tinypaste.com/f7f413


-Charles


--------------070203010303090007030108
Content-Type: text/x-log;
 name="syslog_partial.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog_partial.log"

Mar  2 12:43:14 rman-ss-03 syslogd 1.4.1: restart.
Mar  2 12:43:14 rman-ss-03 kernel: klogd 1.4.1, log source = /proc/kmsg started.
Mar  2 12:43:14 rman-ss-03 kernel: Linux version 2.6.18-194.3.1.el5 (mockbuild@x86-004.build.bos.redhat.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)) #1 SMP Sun May 2 04:17:42 EDT 2010
Mar  2 12:43:14 rman-ss-03 kernel: Command line: ro root=/dev/VolGroup00/LogVol00 elevator=noop
Mar  2 12:43:14 rman-ss-03 kernel: BIOS-provided physical RAM map:
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 0000000000010000 - 00000000000a0000 (usable)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 0000000000100000 - 00000000cf679000 (usable)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 00000000cf679000 - 00000000cf68f000 (reserved)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 00000000cf68f000 - 00000000cf6ce000 (ACPI data)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 00000000cf6ce000 - 00000000d0000000 (reserved)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
Mar  2 12:43:14 rman-ss-03 kernel:  BIOS-e820: 0000000100000000 - 0000000330000000 (usable)
Mar  2 12:43:14 rman-ss-03 kernel: DMI 2.6 present.
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 32 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 34 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 36 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 48 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 50 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 52 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 33 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 35 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 37 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 49 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 51 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: PXM 1 -> APIC 53 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: Node 0 PXM 1 0-d0000000
Mar  2 12:43:14 rman-ss-03 kernel: SRAT: Node 0 PXM 1 0-330000000
Mar  2 12:43:14 rman-ss-03 kernel: Bootmem setup node 0 0000000000000000-0000000330000000
Mar  2 12:43:14 rman-ss-03 kernel: Memory for crash kernel (0x0 to 0x0) notwithin permissible range
Mar  2 12:43:14 rman-ss-03 kernel: disabling kdump
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PM-Timer IO Port: 0x808
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #32 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x22] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #34 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x24] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #36 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x30] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #48 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x32] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #50 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x34] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #52 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x21] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #33 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x08] lapic_id[0x23] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #35 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x09] lapic_id[0x25] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #37 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x31] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #49 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x33] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #51 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x35] enabled)
Mar  2 12:43:14 rman-ss-03 kernel: Processor #53 6:12 APIC version 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2c] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2d] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x10] lapic_id[0x2f] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x11] lapic_id[0x30] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x12] lapic_id[0x31] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x13] lapic_id[0x32] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x14] lapic_id[0x33] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x15] lapic_id[0x34] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x16] lapic_id[0x35] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x17] lapic_id[0x36] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x18] lapic_id[0x37] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x19] lapic_id[0x38] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x39] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x3a] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x3b] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x3c] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x3d] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x3e] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC (acpi_id[0x20] lapic_id[0x3f] disabled)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
Mar  2 12:43:14 rman-ss-03 kernel: IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: IOAPIC (id[0x01] address[0xfec80000] gsi_base[32])
Mar  2 12:43:14 rman-ss-03 kernel: IOAPIC[1]: apic_id 1, version 32, address 0xfec80000, GSI 32-55
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Mar  2 12:43:14 rman-ss-03 kernel: Setting APIC routing to clustered
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: HPET id: 0x8086a301 base: 0xfed00000
Mar  2 12:43:14 rman-ss-03 kernel: Using ACPI (MADT) for SMP configuration information
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000000a0000 - 0000000000100000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000cf679000 - 00000000cf68f000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000cf68f000 - 00000000cf6ce000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000cf6ce000 - 00000000d0000000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000d0000000 - 00000000e0000000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000e0000000 - 00000000f0000000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000f0000000 - 00000000fe000000
Mar  2 12:43:14 rman-ss-03 kernel: Nosave address range: 00000000fe000000 - 0000000100000000
Mar  2 12:43:14 rman-ss-03 kernel: Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
Mar  2 12:43:14 rman-ss-03 kernel: SMP: Allowing 32 CPUs, 20 hotplug CPUs
Mar  2 12:43:14 rman-ss-03 kernel: Built 1 zonelists.  Total pages: 3096172
Mar  2 12:43:14 rman-ss-03 kernel: Kernel command line: ro root=/dev/VolGroup00/LogVol00 elevator=noop
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#0
Mar  2 12:43:14 rman-ss-03 kernel: PID hash table entries: 4096 (order: 12, 32768 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: Console: colour VGA+ 80x25
Mar  2 12:43:14 rman-ss-03 kernel: Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: Checking aperture...
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: DMAR not present
Mar  2 12:43:14 rman-ss-03 kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Mar  2 12:43:14 rman-ss-03 kernel: Placing software IO TLB between 0x2928000 - 0x6928000
Mar  2 12:43:14 rman-ss-03 kernel: Memory: 12289168k/13369344k available (2573k kernel code, 283540k reserved, 1305k data, 212k init)
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.28 BogoMIPS (lpj=3325144)
Mar  2 12:43:14 rman-ss-03 kernel: Security Framework v1.0.0 initialized
Mar  2 12:43:14 rman-ss-03 kernel: SELinux:  Initializing.
Mar  2 12:43:14 rman-ss-03 kernel: selinux_register_security:  Registering secondary module capability
Mar  2 12:43:14 rman-ss-03 kernel: Capability LSM initialized as secondary
Mar  2 12:43:14 rman-ss-03 kernel: Mount-cache hash table entries: 256
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 0/20 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: using mwait in idle threads.
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU0: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to UP code
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: Core revision 20060707
Mar  2 12:43:14 rman-ss-03 kernel: Using local APIC timer interrupts.
Mar  2 12:43:14 rman-ss-03 kernel: Detected 8.312 MHz APIC timer.
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 1/12 APIC 0x22
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#1
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.98 BogoMIPS (lpj=3324993)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 1/22 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU1: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 2/12 APIC 0x24
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#2
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.97 BogoMIPS (lpj=3324985)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 2/24 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 2
Mar  2 12:43:14 rman-ss-03 kernel: CPU2: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 3/12 APIC 0x30
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#3
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.86 BogoMIPS (lpj=3324931)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 3/30 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 8
Mar  2 12:43:14 rman-ss-03 kernel: CPU3: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 4/12 APIC 0x32
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#4
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.95 BogoMIPS (lpj=3324978)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 4/32 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 9
Mar  2 12:43:14 rman-ss-03 kernel: CPU4: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 5/12 APIC 0x34
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#5
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.95 BogoMIPS (lpj=3324976)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 5/34 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 10
Mar  2 12:43:14 rman-ss-03 kernel: CPU5: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 6/12 APIC 0x21
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#6
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.95 BogoMIPS (lpj=3324975)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 6/21 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU6: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 7/12 APIC 0x23
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#7
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.92 BogoMIPS (lpj=3324961)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 7/23 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU7: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 8/12 APIC 0x25
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#8
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.96 BogoMIPS (lpj=3324982)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 8/25 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 2
Mar  2 12:43:14 rman-ss-03 kernel: CPU8: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 9/12 APIC 0x31
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#9
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.95 BogoMIPS (lpj=3324977)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 9/31 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 8
Mar  2 12:43:14 rman-ss-03 kernel: CPU9: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 10/12 APIC 0x33
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#10
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.78 BogoMIPS (lpj=3324891)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 10/33 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 9
Mar  2 12:43:14 rman-ss-03 kernel: CPU10: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: SMP alternatives: switching to SMP code
Mar  2 12:43:14 rman-ss-03 kernel: Booting processor 11/12 APIC 0x35
Mar  2 12:43:14 rman-ss-03 kernel: Initializing CPU#11
Mar  2 12:43:14 rman-ss-03 kernel: Calibrating delay using timer specific routine.. 6649.95 BogoMIPS (lpj=3324977)
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L2 cache: 256K
Mar  2 12:43:14 rman-ss-03 kernel: CPU: L3 cache: 12288K
Mar  2 12:43:14 rman-ss-03 kernel: CPU 11/35 -> Node 0
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Physical Processor ID: 1
Mar  2 12:43:14 rman-ss-03 kernel: CPU: Processor Core ID: 10
Mar  2 12:43:14 rman-ss-03 kernel: CPU11: Thermal monitoring enabled (TM1)
Mar  2 12:43:14 rman-ss-03 kernel: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
Mar  2 12:43:14 rman-ss-03 kernel: Brought up 12 CPUs
Mar  2 12:43:14 rman-ss-03 kernel: testing NMI watchdog ... OK.
Mar  2 12:43:14 rman-ss-03 kernel: time.c: Using 14.318180 MHz WALL HPET GTOD HPET/TSC timer.
Mar  2 12:43:14 rman-ss-03 kernel: time.c: Detected 3325.144 MHz processor.
Mar  2 12:43:14 rman-ss-03 kernel: migration_cost=1,13
Mar  2 12:43:14 rman-ss-03 kernel: checking if image is initramfs... it is
Mar  2 12:43:14 rman-ss-03 kernel: Freeing initrd memory: 3490k freed
Mar  2 12:43:14 rman-ss-03 kernel: NET: Registered protocol family 16
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: bus type pci registered
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Using MMCONFIG at e0000000
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: Interpreter enabled
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: Using IOAPIC for interrupt routing
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: No dock devices found.
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Transparent bridge - 0000:00:1e.0
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 11 14 *15)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 *14 15)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 *11 14 15)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 *10 11 14 15)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 *5 6 7 10 11 14 15)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 *6 7 10 11 14 15)
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 *14 15)
Mar  2 12:43:14 rman-ss-03 kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Mar  2 12:43:14 rman-ss-03 kernel: pnp: PnP ACPI init
Mar  2 12:43:14 rman-ss-03 kernel: pnp: PnP ACPI: found 12 devices
Mar  2 12:43:14 rman-ss-03 kernel: usbcore: registered new driver usbfs
Mar  2 12:43:14 rman-ss-03 kernel: usbcore: registered new driver hub
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Using ACPI for IRQ routing
Mar  2 12:43:14 rman-ss-03 kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Mar  2 12:43:14 rman-ss-03 kernel: NetLabel: Initializing
Mar  2 12:43:14 rman-ss-03 kernel: NetLabel:  domain hash size = 128
Mar  2 12:43:14 rman-ss-03 kernel: NetLabel:  protocols = UNLABELED CIPSOv4
Mar  2 12:43:14 rman-ss-03 kernel: NetLabel:  unlabeled traffic allowed by default
Mar  2 12:43:14 rman-ss-03 kernel: hpet0: at MMIO 0xfed00000 (virtual 0xffffffffff5fe000), IRQs 2, 8, 0, 0
Mar  2 12:43:14 rman-ss-03 kernel: hpet0: 4 64-bit timers, 14318180 Hz
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: DMAR not present
Mar  2 12:43:14 rman-ss-03 kernel: PCI-GART: No AMD northbridge found.
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0x800-0x87f could not be reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0x880-0x8ff has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0x900-0x91f has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0x920-0x923 has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0x924-0x924 has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0xc00-0xc7f has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:07: ioport range 0xca0-0xca7 has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:08: ioport range 0xca8-0xca8 has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: pnp: 00:08: ioport range 0xcac-0xcac has been reserved
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:01.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: d6000000-d9ffffff
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:03.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: da000000-ddffffff
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:04.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: f000-ffff
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: df100000-df1fffff
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:05.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: e000-efff
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: df200000-df3fffff
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:06.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:07.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: d000-dfff
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: df400000-df5fffff
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:09.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel: PCI: Bridge: 0000:00:1e.0
Mar  2 12:43:14 rman-ss-03 kernel:   IO window: disabled.
Mar  2 12:43:14 rman-ss-03 kernel:   MEM window: de000000-deffffff
Mar  2 12:43:14 rman-ss-03 kernel:   PREFETCH window 0x00000000d5800000-0x00000000d5ffffff
Mar  2 12:43:14 rman-ss-03 kernel: GSI 16 sharing vector 0xA9 and IRQ 16
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 53 (level, low) -> IRQ 169
Mar  2 12:43:14 rman-ss-03 kernel: NET: Registered protocol family 2
Mar  2 12:43:14 rman-ss-03 kernel: IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: TCP: Hash tables configured (established 262144 bind 65536)
Mar  2 12:43:14 rman-ss-03 kernel: TCP reno registered
Mar  2 12:43:14 rman-ss-03 kernel: audit: initializing netlink socket (disabled)
Mar  2 12:43:14 rman-ss-03 kernel: type=2000 audit(1299069684.406:1): initialized
Mar  2 12:43:14 rman-ss-03 kernel: Total HugeTLB memory allocated, 0
Mar  2 12:43:14 rman-ss-03 kernel: VFS: Disk quotas dquot_6.5.1
Mar  2 12:43:14 rman-ss-03 kernel: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Mar  2 12:43:14 rman-ss-03 kernel: Initializing Cryptographic API
Mar  2 12:43:14 rman-ss-03 kernel: alg: No test for crc32c (crc32c-generic)
Mar  2 12:43:14 rman-ss-03 kernel: ksign: Installing public key data
Mar  2 12:43:14 rman-ss-03 kernel: Loading keyring
Mar  2 12:43:14 rman-ss-03 kernel: - Added public key AF2174DC3FA76E9F
Mar  2 12:43:14 rman-ss-03 kernel: - User ID: Red Hat, Inc. (Kernel Module GPG key)
Mar  2 12:43:14 rman-ss-03 kernel: io scheduler noop registered (default)
Mar  2 12:43:14 rman-ss-03 kernel: io scheduler anticipatory registered
Mar  2 12:43:14 rman-ss-03 kernel: io scheduler deadline registered
Mar  2 12:43:14 rman-ss-03 kernel: io scheduler cfq registered
Mar  2 12:43:14 rman-ss-03 kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU0 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU1 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU2 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU3 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU4 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU5 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU6 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU7 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU8 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU9 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU10 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: CPU11 (power states: C1[C1] C2[C3])
Mar  2 12:43:14 rman-ss-03 kernel: Real Time Clock Driver v1.12ac
Mar  2 12:43:14 rman-ss-03 kernel: Non-volatile memory driver v1.2
Mar  2 12:43:14 rman-ss-03 kernel: Linux agpgart interface v0.101 (c) Dave Jones
Mar  2 12:43:14 rman-ss-03 kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Mar  2 12:43:14 rman-ss-03 kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar  2 12:43:14 rman-ss-03 kernel: serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Mar  2 12:43:14 rman-ss-03 kernel: 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar  2 12:43:14 rman-ss-03 kernel: 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Mar  2 12:43:14 rman-ss-03 kernel: brd: module loaded
Mar  2 12:43:14 rman-ss-03 kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Mar  2 12:43:14 rman-ss-03 kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Mar  2 12:43:14 rman-ss-03 kernel: ide-floppy driver 0.99.newide
Mar  2 12:43:14 rman-ss-03 kernel: usbcore: registered new driver hiddev
Mar  2 12:43:14 rman-ss-03 kernel: usbcore: registered new driver usbhid
Mar  2 12:43:14 rman-ss-03 kernel: drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Mar  2 12:43:14 rman-ss-03 kernel: PNP: No PS/2 controller found. Probing ports directly.
Mar  2 12:43:14 rman-ss-03 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Mar  2 12:43:14 rman-ss-03 kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Mar  2 12:43:14 rman-ss-03 kernel: mice: PS/2 mouse device common for all mice
Mar  2 12:43:14 rman-ss-03 kernel: md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
Mar  2 12:43:14 rman-ss-03 kernel: md: bitmap version 4.39
Mar  2 12:43:14 rman-ss-03 kernel: TCP bic registered
Mar  2 12:43:14 rman-ss-03 kernel: Initializing IPsec netlink socket
Mar  2 12:43:14 rman-ss-03 kernel: NET: Registered protocol family 1
Mar  2 12:43:14 rman-ss-03 kernel: NET: Registered protocol family 17
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: (supports S0 S4 S5)
Mar  2 12:43:14 rman-ss-03 kernel: Initalizing network drop monitor service
Mar  2 12:43:14 rman-ss-03 kernel: Freeing unused kernel memory: 212k freed
Mar  2 12:43:14 rman-ss-03 kernel: Write protecting the kernel read-only data: 504k
Mar  2 12:43:14 rman-ss-03 kernel: GSI 17 sharing vector 0x32 and IRQ 17
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 19 (level, low) -> IRQ 50
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1a.7: EHCI Host Controller
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1a.7: debug port 1
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1a.7: irq 50, io mem 0xdf0ff800
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Mar  2 12:43:14 rman-ss-03 kernel: usb usb1: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 1-0:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 1-0:1.0: 4 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: GSI 18 sharing vector 0x3A and IRQ 18
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 58
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1d.7: debug port 1
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1d.7: irq 58, io mem 0xdf0ffc00
Mar  2 12:43:14 rman-ss-03 kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Mar  2 12:43:14 rman-ss-03 kernel: usb usb2: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 2-0:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 2-0:1.0: 4 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: USB Universal Host Controller Interface driver v3.0
Mar  2 12:43:14 rman-ss-03 kernel: GSI 19 sharing vector 0x42 and IRQ 19
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 17 (level, low) -> IRQ 66
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1a.0: UHCI Host Controller
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1a.0: irq 66, io base 0x0000cc40
Mar  2 12:43:14 rman-ss-03 kernel: usb usb3: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 3-0:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 3-0:1.0: 2 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: GSI 20 sharing vector 0x4A and IRQ 20
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 18 (level, low) -> IRQ 74
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1a.1: UHCI Host Controller
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1a.1: irq 74, io base 0x0000cc60
Mar  2 12:43:14 rman-ss-03 kernel: usb usb4: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 4-0:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 4-0:1.0: 2 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 58
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1d.0: irq 58, io base 0x0000cc80
Mar  2 12:43:14 rman-ss-03 kernel: usb usb5: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 5-0:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 5-0:1.0: 2 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: usb 1-3: new high speed USB device using ehci_hcd and address 3
Mar  2 12:43:14 rman-ss-03 kernel: GSI 21 sharing vector 0x52 and IRQ 21
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 20 (level, low) -> IRQ 82
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
Mar  2 12:43:14 rman-ss-03 kernel: uhci_hcd 0000:00:1d.1: irq 82, io base 0x0000cca0
Mar  2 12:43:14 rman-ss-03 kernel: usb usb6: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 6-0:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 6-0:1.0: 2 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: usb 1-3: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: hub 1-3:1.0: USB hub found
Mar  2 12:43:14 rman-ss-03 kernel: hub 1-3:1.0: 3 ports detected
Mar  2 12:43:14 rman-ss-03 kernel: SCSI subsystem initialized
Mar  2 12:43:14 rman-ss-03 kernel: megasas: 00.00.04.17-RH1 Wed. Nov. 25, 11:41:51 PST 2009
Mar  2 12:43:14 rman-ss-03 kernel: megasas: 0x1000:0x0079:0x1028:0x1f17: bus 3:slot 0:func 0
Mar  2 12:43:14 rman-ss-03 kernel: GSI 22 sharing vector 0x5A and IRQ 22
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 33 (level, low) -> IRQ 90
Mar  2 12:43:14 rman-ss-03 kernel: megasas: FW now in Ready state
Mar  2 12:43:14 rman-ss-03 kernel: scsi0 : LSI SAS based MegaRAID driver
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: SEAGATE   Model: ST32000444SS      Rev: KS68
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: SEAGATE   Model: ST32000444SS      Rev: KS68
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: SEAGATE   Model: ST32000444SS      Rev: KS68
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: SEAGATE   Model: ST32000444SS      Rev: KS68
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: SEAGATE   Model: ST32000444SS      Rev: KS68
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: SEAGATE   Model: ST32000444SS      Rev: KS68
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DP        Model: BACKPLANE         Rev: 1.07
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Enclosure                          ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: PERC H700         Rev: 2.30
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sda: 3905945600 512-byte hdwr sectors (1999844 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sda: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sda: drive cache: write back
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sda: 3905945600 512-byte hdwr sectors (1999844 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sda: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sda: drive cache: write back
Mar  2 12:43:14 rman-ss-03 kernel:  sda: sda1 sda2
Mar  2 12:43:14 rman-ss-03 kernel: sd 0:2:0:0: Attached scsi disk sda
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: PERC H700         Rev: 2.30
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: sdb : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdb: 11717836800 512-byte hdwr sectors (5999532 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdb: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdb: drive cache: write back
Mar  2 12:43:14 rman-ss-03 kernel: sdb : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdb: 11717836800 512-byte hdwr sectors (5999532 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdb: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdb: drive cache: write back
Mar  2 12:43:14 rman-ss-03 kernel:  sdb: unknown partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 0:2:1:0: Attached scsi disk sdb
Mar  2 12:43:14 rman-ss-03 kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas version 02.00.02.00 loaded
Mar  2 12:43:14 rman-ss-03 kernel: scsi1 : Fusion MPT SAS Host
Mar  2 12:43:14 rman-ss-03 kernel: GSI 23 sharing vector 0x62 and IRQ 23
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 34 (level, low) -> IRQ 98
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (12292872 kB)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: PCI-MSI-X enabled: IRQ 106
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: iomem(0xdf3b0000), mapped(0xffffc20000060000), size(65536)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: ioport(0xec00), size(256)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: sending diag reset !!
Mar  2 12:43:14 rman-ss-03 kernel: usb 3-1: new low speed USB device using uhci_hcd and address 2
Mar  2 12:43:14 rman-ss-03 kernel: usb 3-1: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: input: Avocent Avocent AVRIQ-USB as /class/input/input0
Mar  2 12:43:14 rman-ss-03 kernel: input: USB HID v1.10 Keyboard [Avocent Avocent AVRIQ-USB] on usb-0000:00:1a.0-1
Mar  2 12:43:14 rman-ss-03 kernel: input: Avocent Avocent AVRIQ-USB as /class/input/input1
Mar  2 12:43:14 rman-ss-03 kernel: input: USB HID v1.10 Mouse [Avocent Avocent AVRIQ-USB] on usb-0000:00:1a.0-1
Mar  2 12:43:14 rman-ss-03 kernel: usb 5-2: new full speed USB device using uhci_hcd and address 2
Mar  2 12:43:14 rman-ss-03 kernel: usb 5-2: configuration #1 chosen from 1 choice
Mar  2 12:43:14 rman-ss-03 kernel: input: Avocent USB Composite Device-0 as /class/input/input2
Mar  2 12:43:14 rman-ss-03 kernel: input: USB HID v1.00 Keyboard [Avocent USB Composite Device-0] on usb-0000:00:1d.0-2
Mar  2 12:43:14 rman-ss-03 kernel: input: Avocent USB Composite Device-0 as /class/input/input3
Mar  2 12:43:14 rman-ss-03 kernel: input: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-0000:00:1d.0-2
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: diag reset: SUCCESS
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: Allocated physical memory: size(1125 kB)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: Current Controller Queue Depth(490), Max Controller Queue Depth(3999)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: LSISAS2008: FWVersion(02.15.59.00), ChipRevision(0x02), BiosVersion(07.01.08.00)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: Dell 6Gbps SAS HBA: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1C)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: sending port enable !!
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: host_add: handle(0x0001), sas_addr(0x5a4badb044656000), phys(8)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas0: port enable: SUCCESS
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: MD32xx            Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: SSP: handle(0x0009), sas_addr(0x5842b2b45294f914), device_name(0xb4b2425814f99452)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: SSP: enclosure_logical_id(0x5a4badb044656000), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: MD32xx            Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:1: SSP: handle(0x0009), sas_addr(0x5842b2b45294f914), device_name(0xb4b2425814f99452)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:1: SSP: enclosure_logical_id(0x5a4badb044656000), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:1: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel: sdc : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdc: 42965760212 512-byte hdwr sectors (21998469 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdc: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdc: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel: sdc : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdc: 42965760212 512-byte hdwr sectors (21998469 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdc: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdc: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel:  sdc:end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 1
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 1
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 1
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 1
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 1
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Dev sdc: unable to read RDB block 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdc, sector 0
Mar  2 12:43:14 rman-ss-03 kernel:  unable to read partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:1: Attached scsi disk sdc
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: MD32xx            Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:2: SSP: handle(0x0009), sas_addr(0x5842b2b45294f914), device_name(0xb4b2425814f99452)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:2: SSP: enclosure_logical_id(0x5a4badb044656000), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:2: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel: sdd : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdd: 42965762048 512-byte hdwr sectors (21998470 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdd: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdd: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel: sdd : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdd: 42965762048 512-byte hdwr sectors (21998470 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdd: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdd: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel:  sdd: unknown partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:2: Attached scsi disk sdd
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: Universal Xport   Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:31: SSP: handle(0x0009), sas_addr(0x5842b2b45294f914), device_name(0xb4b2425814f99452)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:31: SSP: enclosure_logical_id(0x5a4badb044656000), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:31: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sde: 40960 512-byte hdwr sectors (21 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sde: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sde: drive cache: write through w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sde: 40960 512-byte hdwr sectors (21 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sde: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sde: drive cache: write through w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel:  sde: unknown partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:31: Attached scsi disk sde
Mar  2 12:43:14 rman-ss-03 kernel: scsi2 : Fusion MPT SAS Host
Mar  2 12:43:14 rman-ss-03 kernel: GSI 24 sharing vector 0x72 and IRQ 24
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 38 (level, low) -> IRQ 114
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (12292872 kB)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: PCI-MSI-X enabled: IRQ 122
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: iomem(0xdf5b0000), mapped(0xffffc200100a0000), size(65536)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: ioport(0xdc00), size(256)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: sending diag reset !!
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: diag reset: SUCCESS
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: Allocated physical memory: size(1125 kB)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: Current Controller Queue Depth(490), Max Controller Queue Depth(3999)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: Scatter Gather Elements per IO(128)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: LSISAS2008: FWVersion(02.15.59.00), ChipRevision(0x02), BiosVersion(07.01.08.00)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: Dell 6Gbps SAS HBA: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1C)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: sending port enable !!
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: host_add: handle(0x0001), sas_addr(0x5a4badb044658e00), phys(8)
Mar  2 12:43:14 rman-ss-03 kernel: mpt2sas1: port enable: SUCCESS
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: MD32xx            Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: SSP: handle(0x0009), sas_addr(0x5842b2b4528f6214), device_name(0xb4b2425814628f52)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: SSP: enclosure_logical_id(0x5a4badb044658e00), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: MD32xx            Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:1: SSP: handle(0x0009), sas_addr(0x5842b2b4528f6214), device_name(0xb4b2425814628f52)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:1: SSP: enclosure_logical_id(0x5a4badb044658e00), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:1: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel: sdf : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdf: 42965760212 512-byte hdwr sectors (21998469 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdf: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdf: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel: sdf : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdf: 42965760212 512-byte hdwr sectors (21998469 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdf: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdf: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel:  sdf: unknown partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:1: Attached scsi disk sdf
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: MD32xx            Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:2: SSP: handle(0x0009), sas_addr(0x5842b2b4528f6214), device_name(0xb4b2425814628f52)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:2: SSP: enclosure_logical_id(0x5a4badb044658e00), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:2: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel: sdg : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdg: 42965762048 512-byte hdwr sectors (21998470 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdg: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdg: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel: sdg : very big device. try to use READ CAPACITY(16).
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdg: 42965762048 512-byte hdwr sectors (21998470 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdg: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdg: drive cache: write back w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel:  sdg:end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: printk: 8 messages suppressed.
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdg, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdg, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 last message repeated 2 times
Mar  2 12:43:14 rman-ss-03 kernel: printk: 2 messages suppressed.
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdg, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: Dev sdg: unable to read RDB block 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdg, sector 0
Mar  2 12:43:14 rman-ss-03 kernel:  unable to read partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:2: Attached scsi disk sdg
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: DELL      Model: Universal Xport   Rev: 0770
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:31: SSP: handle(0x0009), sas_addr(0x5842b2b4528f6214), device_name(0xb4b2425814628f52)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:31: SSP: enclosure_logical_id(0x5a4badb044658e00), slot(3)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:31: qdepth(254), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdh: 40960 512-byte hdwr sectors (21 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdh: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdh: drive cache: write through w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdh: 40960 512-byte hdwr sectors (21 MB)
Mar  2 12:43:14 rman-ss-03 kernel: sdh: Write Protect is off
Mar  2 12:43:14 rman-ss-03 kernel: SCSI device sdh: drive cache: write through w/ FUA
Mar  2 12:43:14 rman-ss-03 kernel:  sdh: unknown partition table
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:31: Attached scsi disk sdh
Mar  2 12:43:14 rman-ss-03 kernel: GSI 25 sharing vector 0x82 and IRQ 25
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 23 (level, low) -> IRQ 130
Mar  2 12:43:14 rman-ss-03 kernel: ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
Mar  2 12:43:14 rman-ss-03 kernel: scsi3 : ata_piix
Mar  2 12:43:14 rman-ss-03 kernel: scsi4 : ata_piix
Mar  2 12:43:14 rman-ss-03 kernel: ata1: SATA max UDMA/133 cmd 0xcc10 ctl 0xcc08 bmdma 0xcc20 irq 130
Mar  2 12:43:14 rman-ss-03 kernel: ata2: SATA max UDMA/133 cmd 0xcc18 ctl 0xcc0c bmdma 0xcc28 irq 130
Mar  2 12:43:14 rman-ss-03 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Mar  2 12:43:14 rman-ss-03 kernel: ata1.00: ATAPI: TEAC DVD-ROM DV-28SW, R.2A, max UDMA/100
Mar  2 12:43:14 rman-ss-03 kernel: ata1.00: configured for UDMA/100
Mar  2 12:43:14 rman-ss-03 kernel: ata2: SATA link down (SStatus 4 SControl 0)
Mar  2 12:43:14 rman-ss-03 kernel:   Vendor: TEAC      Model: DVD-ROM DV-28SW   Rev: R.2A
Mar  2 12:43:14 rman-ss-03 kernel:   Type:   CD-ROM                             ANSI SCSI revision: 05
Mar  2 12:43:14 rman-ss-03 kernel: Initializing USB Mass Storage driver...
Mar  2 12:43:14 rman-ss-03 kernel: usbcore: registered new driver usb-storage
Mar  2 12:43:14 rman-ss-03 kernel: USB Mass Storage support registered.
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: uevent: version 1.0.3
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: ioctl: 4.11.5-ioctl (2007-12-12) initialised: dm-devel@redhat.com
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: multipath: version 1.0.5 loaded
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: rdac: LUN 0 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:1: rdac: LUN 1 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:2: rdac: LUN 2 (owned)
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: rdac: LUN 0 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:1: rdac: LUN 1 (owned)
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:2: rdac: LUN 2 (unowned)
Mar  2 12:43:14 rman-ss-03 kernel: rdac: device handler registered
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: dm-raid45: initialized v0.2594l
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdh, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: printk: 4 messages suppressed.
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 0
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 1
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 2
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 3
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 4
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 5
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sde, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdh, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sde, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdh, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sde, sector 0
Mar  2 12:43:14 rman-ss-03 kernel: kjournald starting.  Commit interval 5 seconds
Mar  2 12:43:14 rman-ss-03 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Mar  2 12:43:14 rman-ss-03 kernel: SELinux:  Disabled at runtime.
Mar  2 12:43:14 rman-ss-03 kernel: input: PC Speaker as /class/input/input4
Mar  2 12:43:14 rman-ss-03 kernel: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.2 (Aug 21, 2009)
Mar  2 12:43:14 rman-ss-03 kernel: GSI 26 sharing vector 0x8A and IRQ 26
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 36 (level, low) -> IRQ 138
Mar  2 12:43:14 rman-ss-03 kernel: eth0: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem d6000000, IRQ 138, node addr 842b2b44f223
Mar  2 12:43:14 rman-ss-03 kernel: GSI 27 sharing vector 0x92 and IRQ 27
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:01:00.1[B] -> GSI 48 (level, low) -> IRQ 146
Mar  2 12:43:14 rman-ss-03 kernel: scsi 0:0:32:0: Attached scsi generic sg0 type 13
Mar  2 12:43:14 rman-ss-03 kernel: sd 0:2:0:0: Attached scsi generic sg1 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 0:2:1:0: Attached scsi generic sg2 type 0
Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: Attached scsi generic sg3 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:1: Attached scsi generic sg4 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:2: Attached scsi generic sg5 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:31: Attached scsi generic sg6 type 0
Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: Attached scsi generic sg7 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:1: Attached scsi generic sg8 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:2: Attached scsi generic sg9 type 0
Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:31: Attached scsi generic sg10 type 0
Mar  2 12:43:14 rman-ss-03 kernel: scsi 3:0:0:0: Attached scsi generic sg11 type 5
Mar  2 12:43:14 rman-ss-03 kernel: eth1: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem d8000000, IRQ 146, node addr 842b2b44f225
Mar  2 12:43:14 rman-ss-03 kernel: GSI 28 sharing vector 0x9A and IRQ 28
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 32 (level, low) -> IRQ 154
Mar  2 12:43:14 rman-ss-03 kernel: eth2: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem da000000, IRQ 154, node addr 842b2b44f227
Mar  2 12:43:14 rman-ss-03 kernel: GSI 29 sharing vector 0xA2 and IRQ 29
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 42 (level, low) -> IRQ 162
Mar  2 12:43:14 rman-ss-03 kernel: eth3: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem dc000000, IRQ 162, node addr 842b2b44f229
Mar  2 12:43:14 rman-ss-03 kernel: printk: 198 messages suppressed.
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 10741440000
Mar  2 12:43:14 rman-ss-03 kernel: sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Mar  2 12:43:14 rman-ss-03 kernel: Uniform CD-ROM driver Revision: 3.20
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sdh, sector 40
Mar  2 12:43:14 rman-ss-03 kernel: end_request: I/O error, dev sde, sector 40
Mar  2 12:43:14 rman-ss-03 kernel: floppy0: no floppy controllers found
Mar  2 12:43:14 rman-ss-03 kernel: lp: driver loaded but no devices found
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: Power Button (FF) [PWRF]
Mar  2 12:43:14 rman-ss-03 kernel: ACPI: Mapper loaded
Mar  2 12:43:14 rman-ss-03 kernel: dell-wmi: No known WMI GUID found
Mar  2 12:43:14 rman-ss-03 kernel: ACPI Exception (evregion-0424): AE_SUPPORT, Returned by Handler for [DataTable] [20060707]
Mar  2 12:43:14 rman-ss-03 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PMI0._GHL] (Node ffff81010b35a470), AE_SUPPORT
Mar  2 12:43:14 rman-ss-03 kernel: ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PMI0._PMC] (Node ffff81010b35a4f0), AE_SUPPORT
Mar  2 12:43:14 rman-ss-03 kernel: ACPI Exception (power_meter-0759): AE_SUPPORT, Evaluating _PMC [20060707]
Mar  2 12:43:14 rman-ss-03 kernel: Device 'power_meter0' does not have a release() function, it is broken and must be fixed.
Mar  2 12:43:14 rman-ss-03 kernel: BUG: warning at drivers/base/core.c:101/device_release() (Tainted: G     )
Mar  2 12:43:14 rman-ss-03 kernel: 
Mar  2 12:43:14 rman-ss-03 kernel: Call Trace:
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff80150c09>] kobject_cleanup+0x53/0x7e
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff80150c34>] kobject_release+0x0/0x9
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff80035400>] kref_put+0x6f/0x7a
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff883610ed>] :power_meter:acpi_power_meter_add+0x158/0x16f
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff801a0378>] acpi_bus_driver_init+0x30/0x57
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff801a1596>] acpi_bus_register_driver+0x95/0xd4
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff88278032>] :power_meter:acpi_power_meter_init+0x25/0x34
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff800a6efa>] sys_init_module+0xaf/0x1f2
Mar  2 12:43:14 rman-ss-03 kernel:  [<ffffffff8005d116>] system_call+0x7e/0x83
Mar  2 12:43:14 rman-ss-03 kernel: 
Mar  2 12:43:14 rman-ss-03 kernel: md: Autodetecting RAID arrays.
Mar  2 12:43:14 rman-ss-03 kernel: md: autorun ...
Mar  2 12:43:14 rman-ss-03 kernel: md: ... autorun DONE.
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: multipath round-robin: version 1.0.0 loaded
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: table: 253:3: multipath: error getting device
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: ioctl: error adding target to table
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: table: 253:3: multipath: error getting device
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: ioctl: error adding target to table
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for failover/failback and device management.
Mar  2 12:43:14 rman-ss-03 kernel: printk: 135 messages suppressed.
Mar  2 12:43:14 rman-ss-03 kernel: Buffer I/O error on device sdc, logical block 10741440052
Mar  2 12:43:14 rman-ss-03 kernel: EXT3 FS on dm-0, internal journal
Mar  2 12:43:14 rman-ss-03 kernel: kjournald starting.  Commit interval 5 seconds
Mar  2 12:43:14 rman-ss-03 kernel: EXT3 FS on sda1, internal journal
Mar  2 12:43:14 rman-ss-03 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Mar  2 12:43:14 rman-ss-03 kernel: EXT4-fs (dm-10): mounted filesystem without journal
Mar  2 12:43:14 rman-ss-03 kernel: EXT4-fs (dm-2): mounted filesystem without journal
Mar  2 12:43:14 rman-ss-03 kernel: EXT4-fs (dm-6): mounted filesystem with ordered data mode
Mar  2 12:43:14 rman-ss-03 kernel: EXT4-fs (dm-7): mounted filesystem with ordered data mode
Mar  2 12:43:14 rman-ss-03 kernel: EXT4-fs (dm-8): mounted filesystem with ordered data mode
Mar  2 12:43:14 rman-ss-03 kernel: EXT4-fs (dm-9): mounted filesystem with ordered data mode
Mar  2 12:43:14 rman-ss-03 kernel: Adding 2097144k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2097144k
Mar  2 12:43:14 rman-ss-03 kernel: IA-32 Microcode Update Driver: v1.14a <tigran@veritas.com>
Mar  2 12:43:14 rman-ss-03 kernel: Loading iSCSI transport class v2.0-871.
Mar  2 12:43:14 rman-ss-03 kernel: 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
Mar  2 12:43:14 rman-ss-03 kernel: All bugs added by David S. Miller <davem@redhat.com>
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: table: 253:11: multipath: error getting device
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: ioctl: error adding target to table
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: table: 253:11: multipath: error getting device
Mar  2 12:43:14 rman-ss-03 kernel: device-mapper: ioctl: error adding target to table
Mar  2 12:43:14 rman-ss-03 kernel: cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
Mar  2 12:43:14 rman-ss-03 kernel: iscsi: registered transport (cxgb3i)
Mar  2 12:43:14 rman-ss-03 kernel: NET: Registered protocol family 10
Mar  2 12:43:14 rman-ss-03 kernel: lo: Disabled Privacy Extensions
Mar  2 12:43:14 rman-ss-03 kernel: IPv6 over IPv4 tunneling driver
Mar  2 12:43:14 rman-ss-03 kernel: Broadcom NetXtreme II CNIC Driver cnic v2.1.0 (Oct 10, 2009)
Mar  2 12:43:14 rman-ss-03 kernel: cnic: Added CNIC device: eth0
Mar  2 12:43:14 rman-ss-03 kernel: cnic: Added CNIC device: eth1
Mar  2 12:43:14 rman-ss-03 kernel: cnic: Added CNIC device: eth2
Mar  2 12:43:14 rman-ss-03 kernel: cnic: Added CNIC device: eth3
Mar  2 12:43:14 rman-ss-03 kernel: Broadcom NetXtreme II iSCSI Driver bnx2i v2.1.0 (Dec 06, 2009)
Mar  2 12:43:14 rman-ss-03 kernel: iscsi: registered transport (bnx2i)
Mar  2 12:43:14 rman-ss-03 kernel: scsi5 : Broadcom Offload iSCSI Initiator
Mar  2 12:43:14 rman-ss-03 kernel: scsi6 : Broadcom Offload iSCSI Initiator
Mar  2 12:43:14 rman-ss-03 kernel: scsi7 : Broadcom Offload iSCSI Initiator
Mar  2 12:43:14 rman-ss-03 kernel: scsi8 : Broadcom Offload iSCSI Initiator
Mar  2 12:43:14 rman-ss-03 kernel: iscsi: registered transport (tcp)
Mar  2 12:43:14 rman-ss-03 kernel: iscsi: registered transport (iser)
Mar  2 12:43:14 rman-ss-03 kernel: iscsi: registered transport (be2iscsi)
Mar  2 12:43:14 rman-ss-03 kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
Mar  2 12:43:14 rman-ss-03 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Mar  2 12:43:14 rman-ss-03 kernel: Netfilter messages via NETLINK v0.30.
Mar  2 12:43:14 rman-ss-03 kernel: ip_conntrack version 2.4 (8192 buckets, 65536 max) - 304 bytes per conntrack
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0: using MSIX
Mar  2 12:43:14 rman-ss-03 kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar  2 12:43:14 rman-ss-03 kernel: bnx2i: iSCSI not supported, dev=eth0
Mar  2 12:43:14 rman-ss-03 kernel: bnx2i: iSCSI not supported, dev=eth0
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
Mar  2 12:43:14 rman-ss-03 kernel: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Down
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Down
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Down
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Down
Mar  2 12:43:14 rman-ss-03 kernel: bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
Mar  2 12:43:14 rman-ss-03 rpc.statd[5160]: Version 1.0.9 Starting
Mar  2 12:43:15 rman-ss-03 kernel: openafs: module license 'http://www.openafs.org/dl/license10.html' taints kernel.
Mar  2 12:43:15 rman-ss-03 kernel: Found system call table at 0xffffffff80288f40 (pattern scan)
Mar  2 12:43:15 rman-ss-03 kernel: Using keyrings, rather than hooking system calls
Mar  2 12:43:15 rman-ss-03 kernel: Found 32-bit system call table at 0xffffffff8028a300 (pattern scan)
Mar  2 12:43:15 rman-ss-03 kernel: Using keyrings, rather than hooking system calls
Mar  2 12:43:15 rman-ss-03 kernel: enabling dynamically allocated vcaches
Mar  2 12:43:15 rman-ss-03 kernel: Starting AFS cache scan...found 446 non-empty cache files (14%).
Mar  2 12:43:16 rman-ss-03 ntpd[5377]: ntpd 4.2.2p1@1.1570-o Thu Nov 26 11:34:34 UTC 2009 (1)
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: precision = 1.000 usec
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: Listening on interface wildcard, 0.0.0.0#123 Disabled
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: Listening on interface wildcard, ::#123 Disabled
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: Listening on interface lo, ::1#123 Enabled
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: Listening on interface eth0, fe80::862b:2bff:fe44:f223#123 Enabled
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: Listening on interface lo, 127.0.0.1#123 Enabled
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: Listening on interface eth0, 172.19.224.92#123 Enabled
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: kernel time sync status 0040
Mar  2 12:43:16 rman-ss-03 xinetd[5361]: xinetd Version 2.3.14 started with libwrap loadavg labeled-networking options compiled in.
Mar  2 12:43:16 rman-ss-03 xinetd[5361]: Started working: 0 available services
Mar  2 12:43:16 rman-ss-03 ntpd[5378]: frequency initialized 27.365 PPM from /var/lib/ntp/drift
Mar  2 12:43:16 rman-ss-03 kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Mar  2 12:43:16 rman-ss-03 kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Mar  2 12:43:16 rman-ss-03 kernel: NFSD: starting 90-second grace period
Mar  2 12:43:16 rman-ss-03 rpc.idmapd[5573]: libnfsidmap: using domain: localdomain 
Mar  2 12:43:16 rman-ss-03 rpc.idmapd[5573]: libnfsidmap: using translation method: nsswitch 
Mar  2 12:43:16 rman-ss-03 rpc.idmapd[5574]: Expiration time is 600 seconds.
Mar  2 12:43:16 rman-ss-03 rpc.idmapd[5574]: Opened /proc/net/rpc/nfs4.nametoid/channel
Mar  2 12:43:16 rman-ss-03 rpc.idmapd[5574]: Opened /proc/net/rpc/nfs4.idtoname/channel
Mar  2 12:43:17 rman-ss-03 gpm[5621]: *** info [startup.c(95)]: 
Mar  2 12:43:17 rman-ss-03 gpm[5621]: Started gpm successfully. Entered daemon mode.
Mar  2 12:43:18 rman-ss-03 kernel: end_request: I/O error, dev sdh, sector 40
Mar  2 12:43:18 rman-ss-03 kernel: printk: 35 messages suppressed.
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 5
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 6
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 7
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 8
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 9
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 10
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 11
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 12
Mar  2 12:43:18 rman-ss-03 kernel: Buffer I/O error on device sdh, logical block 13
Mar  2 12:43:19 rman-ss-03 kernel: end_request: I/O error, dev sde, sector 40
Mar  2 12:43:27 rman-ss-03 SMagent: SMagent started. PID=5818
Mar  2 12:43:27 rman-ss-03 smartd[5845]: smartd version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Home page is http://smartmontools.sourceforge.net/  
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Opened configuration file /etc/smartd.conf 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scanning devices 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Problem creating device name scan list 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sda, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sda, IE (SMART) not enabled, skip device Try 'smartctl -s on /dev/sda' to turn on SMART features 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdb, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdb, IE (SMART) not enabled, skip device Try 'smartctl -s on /dev/sdb' to turn on SMART features 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdc, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdc, is SMART capable. Adding to "monitor" list. 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdd, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdd, is SMART capable. Adding to "monitor" list. 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sde, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sde, is SMART capable. Adding to "monitor" list. 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdf, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdf, is SMART capable. Adding to "monitor" list. 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdg, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdg, is SMART capable. Adding to "monitor" list. 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdh, opened 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Device: /dev/sdh, is SMART capable. Adding to "monitor" list. 
Mar  2 12:43:27 rman-ss-03 smartd[5845]: Monitoring 0 ATA and 6 SCSI devices 
Mar  2 12:43:27 rman-ss-03 smartd[5852]: smartd has fork()ed into background mode. New PID=5852. 
Mar  2 12:43:27 rman-ss-03 S99SMmonitor: S99SMmonitor started. PID=5862
Mar  2 12:43:35 rman-ss-03 kernel: REJECT_BY_DEFAULT: IN=eth0 OUT= MAC=84:2b:2b:44:f2:23:00:50:56:75:c0:2a:08:00 SRC=172.19.224.8 DST=172.19.224.92 LEN=111 TOS=0x00 PREC=0x00 TTL=64 ID=30325 PROTO=UDP SPT=427 DPT=38728 LEN=91 
Mar  2 12:43:35 rman-ss-03 kernel: REJECT_BY_DEFAULT: IN=eth0 OUT= MAC=84:2b:2b:44:f2:23:00:50:56:73:c5:c3:08:00 SRC=172.19.224.107 DST=172.19.224.92 LEN=108 TOS=0x00 PREC=0x00 TTL=64 ID=63184 PROTO=UDP SPT=427 DPT=38728 LEN=88 
Mar  2 12:43:35 rman-ss-03 kernel: REJECT_BY_DEFAULT: IN=eth0 OUT= MAC=84:2b:2b:44:f2:23:00:50:56:71:82:b8:08:00 SRC=172.19.224.18 DST=172.19.224.92 LEN=111 TOS=0x00 PREC=0x00 TTL=64 ID=3542 PROTO=UDP SPT=427 DPT=38728 LEN=91 
Mar  2 12:43:35 rman-ss-03 kernel: REJECT_BY_DEFAULT: IN=eth0 OUT= MAC=84:2b:2b:44:f2:23:00:50:56:70:3b:4d:08:00 SRC=172.19.224.66 DST=172.19.224.92 LEN=108 TOS=0x00 PREC=0x00 TTL=64 ID=61075 PROTO=UDP SPT=427 DPT=38728 LEN=88 
Mar  2 12:43:35 rman-ss-03 kernel: REJECT_BY_DEFAULT: IN=eth0 OUT= MAC=84:2b:2b:44:f2:23:00:50:56:4a:bb:66:08:00 SRC=172.19.224.86 DST=172.19.224.92 LEN=108 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=427 DPT=38728 LEN=88 
Mar  2 12:43:40 rman-ss-03 kernel: Fusion MPT base driver 3.04.13rh
Mar  2 12:43:40 rman-ss-03 kernel: Copyright (c) 1999-2008 LSI Corporation
Mar  2 12:43:40 rman-ss-03 kernel: Fusion MPT misc device (ioctl) driver 3.04.13rh
Mar  2 12:43:40 rman-ss-03 kernel: mptctl: Registered with Fusion MPT base driver
Mar  2 12:43:40 rman-ss-03 kernel: mptctl: /dev/mptctl @ (major,minor=10,220)
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON61440> Monitor has started successfully
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON042> Controller ID: 0  Shutdown command received from host
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON000> Controller ID: 0  Firmware initialization started: (PCI ID 0x1000/0x0079/0x1028/0x1f17)
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON001> Controller ID: 0  Image version: 2.30.03-0872
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON141> Controller ID: 0  Battery Present
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON261> Controller ID: 0 Package version 12.3.0-0032
Mar  2 12:43:42 rman-ss-03 MR_MONITOR[5805]: <MRMON266> Controller ID: 0 Board Revision: A00
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON000> Controller ID: 0  Firmware initialization started: (PCI ID 0x1000/0x0079/0x1028/0x1f17)
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON001> Controller ID: 0  Image version: 2.30.03-0872
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON141> Controller ID: 0  Battery Present
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON261> Controller ID: 0 Package version 12.3.0-0032
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON266> Controller ID: 0 Board Revision: A00
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON167> Controller ID: 0  Communication restored on enclosure: :0
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: :32
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Unknown Device Id: :0
Mar  2 12:43:43 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: --:--:0
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Disk Device Id: --:--:0
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: --:--:1
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Disk Device Id: --:--:1
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: --:--:2
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Disk Device Id: --:--:2
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: --:--:3
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Disk Device Id: --:--:3
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: --:--:4
Mar  2 12:43:44 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Disk Device Id: --:--:4
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON091> Controller ID: 0  PD inserted: --:--:5
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON247> Controller ID: 0 Device inserted Device Type: Disk Device Id: --:--:5
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON096> Controller ID: 0  PD Predictive failure: --:--:1
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON113> Controller ID: 0  Unexpected sense: PD = --:--:1 - Failure prediction threshold exceeded, CDB =  0x03  0x00  0x00  0x00  0x40  0x00 , Sense =  0x70  0x00  0x00  0x00  0x00  0x00  0x00  0x0a  0x00  0x00  0x00  0x00  0x5d  0x00  0x43  0x00  0x00  0x06 
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON044> Controller ID: 0  Time established since power on: Time 2011-03-02,12:43:45 55 Seconds
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON149> Controller ID: 0  Battery temperature is normal
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON147> Controller ID: 0  Battery started charging
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON163> Controller ID: 0  Current capacity of the battery is above     threshold
Mar  2 12:43:45 rman-ss-03 MR_MONITOR[5805]: <MRMON113> Controller ID: 0  Unexpected sense: PD = :32 - Invalid field in CDB, CDB =  0x12  0x01  0xc0  0x00  0x9e  0x00 , Sense =  0x70  0x00  0x05  0x00  0x00  0x00  0x00  0x0a  0x00  0x00  0x00  0x00  0x24  0x00  0x00  0x00  0x00  0x00 
Mar  2 12:43:46 rman-ss-03 MR_MONITOR[5805]: <MRMON044> Controller ID: 0  Time established since power on: Time 2011-03-02,12:43:46 223 Seconds
Mar  2 12:44:40 rman-ss-03 sudo:     casl : TTY=pts/0 ; PWD=/home/casl ; USER=root ; COMMAND=/bin/bash --login
Mar  2 12:44:57 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.24:946 for /rman/p01 (/rman/p01)
Mar  2 12:44:57 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.24:947 for /rman/p02 (/rman/p02)
Mar  2 12:44:57 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.24:948 for /rman/d01 (/rman/d01)
Mar  2 12:44:57 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.24:949 for /rman/d02 (/rman/d02)
Mar  2 12:44:57 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.24:950 for /rman/e01 (/rman/e01)
Mar  2 12:44:57 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.24:951 for /rman/e02 (/rman/e02)
Mar  2 12:45:04 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.27:659 for /rman/p01 (/rman/p01)
Mar  2 12:45:04 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.27:660 for /rman/p02 (/rman/p02)
Mar  2 12:45:04 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.27:661 for /rman/d01 (/rman/d01)
Mar  2 12:45:04 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.27:663 for /rman/d02 (/rman/d02)
Mar  2 12:45:04 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.27:664 for /rman/e01 (/rman/e01)
Mar  2 12:45:04 rman-ss-03 mountd[5545]: authenticated mount request from 172.19.224.27:665 for /rman/e02 (/rman/e02)
Mar  2 12:46:35 rman-ss-03 ntpd[5378]: synchronized to 128.2.1.22, stratum 2
Mar  2 12:46:34 rman-ss-03 ntpd[5378]: time reset -0.487138 s
Mar  2 12:46:34 rman-ss-03 ntpd[5378]: kernel time sync enabled 0001
Mar  2 12:50:22 rman-ss-03 ntpd[5378]: synchronized to 128.2.1.22, stratum 2
Mar  2 12:56:51 rman-ss-03 kernel: FAILED
Mar  2 12:56:51 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:51 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:51 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:51 rman-ss-03 kernel: 
Mar  2 12:56:52 rman-ss-03 kernel: FAILED
Mar  2 12:56:52 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:52 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:52 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:52 rman-ss-03 kernel: 
Mar  2 12:56:54 rman-ss-03 kernel: FAILED
Mar  2 12:56:54 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:54 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:54 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:54 rman-ss-03 kernel: 
Mar  2 12:56:55 rman-ss-03 kernel: FAILED
Mar  2 12:56:55 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:55 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:55 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:55 rman-ss-03 kernel: 
Mar  2 12:56:57 rman-ss-03 kernel: FAILED
Mar  2 12:56:57 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:57 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:57 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:57 rman-ss-03 kernel: 
Mar  2 12:56:58 rman-ss-03 kernel: FAILED
Mar  2 12:56:58 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:56:58 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:56:58 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:56:58 rman-ss-03 kernel: 
Mar  2 12:57:11 rman-ss-03 kernel: FAILED
Mar  2 12:57:11 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:11 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:11 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:11 rman-ss-03 kernel: 
Mar  2 12:57:12 rman-ss-03 kernel: FAILED
Mar  2 12:57:12 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:12 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:12 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:12 rman-ss-03 kernel: 
Mar  2 12:57:14 rman-ss-03 kernel: FAILED
Mar  2 12:57:14 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:14 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:14 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:14 rman-ss-03 kernel: 
Mar  2 12:57:16 rman-ss-03 kernel: FAILED
Mar  2 12:57:16 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:16 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:16 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:16 rman-ss-03 kernel: 
Mar  2 12:57:17 rman-ss-03 kernel: FAILED
Mar  2 12:57:17 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:17 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:17 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:17 rman-ss-03 kernel: 
Mar  2 12:57:19 rman-ss-03 kernel: FAILED
Mar  2 12:57:19 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:19 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:19 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:19 rman-ss-03 kernel: 
Mar  2 12:57:20 rman-ss-03 kernel: FAILED
Mar  2 12:57:20 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:20 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:20 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:20 rman-ss-03 kernel: 
Mar  2 12:57:22 rman-ss-03 kernel: FAILED
Mar  2 12:57:22 rman-ss-03 kernel:   status = 1, message = 00, host = 0, driver = 08
Mar  2 12:57:22 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal Request
Mar  2 12:57:22 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  2 12:57:22 rman-ss-03 kernel: 

--------------070203010303090007030108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070203010303090007030108--
