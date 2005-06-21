From: William Alberto Lovaton Tovar <williama_lovaton@coomeva.com.co>
Subject: Fibre Channel related crash
Date: Tue, 21 Jun 2005 08:49:44 -0500
Message-ID: <1119361784.24150.47.camel@nalwalovaton>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_000_01C57668.18116259"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C57668.18116259
Content-Type: text/plain;
	charset="utf-8"

Hi there,

I'm writing here because I'm not sure where to ask for help.  If this
doesn't belong here please point me to the right list or bug report.

I have an IBM xSeries 445 server (SMP 8x HT, 18GB RAM, SAN) with Fedora
Core 3 and Oracle 9.2.0.6 running an enterprise web application with
PHP.  The app is very transactional and both server are under heavy load
(7+ millions of requests per day in apache).

The database have been working great with excellent performance but I
have been experimenting some random crashes, yesterday being the last
one after 75 days of uptime.  The messages log doesn't say anything
about the problem but I think it is related to the QLogic FC interface
since the Oracle datafiles are stored in a SAN.

I reported a bug against the tg3 NIC driver because I was seeing some
backtraces in the log but that is not what is causing the server crash.
David S. Miller have been working on it:
[] https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=152929

When I rebooted the server, some errors showed up in the log about
Buffer I/O error on an scsi device.

I have to say that I couldn't install Fedora Core 3 with the SAN
partitions enabled since it will confuse the installer thinking that
those "exported" disks were the first ones and the local disk was the
last one.

Without the SAN:
Local disk --> sda

With the SAN:
SAN 1      --> sda
SAN 2      --> sdb
Local disk --> sdc

I had to do the installation without the SAN and after "presenting" the
SAN disks to the server I got the second layout.  It have been working
fine that way since then... weird!.

You can see more information about this in the bug report above.

Since I don't know exactly where to look I'm attaching both, the
messages log after reboot with the mentioned errors and the output of
'lspci -v' so that you can see the hardware in my setup.

I hope you can give me any hint about this or point to any place where I
can get more information.  Under what bugzilla module should I create a
bug report?

Thanx,


-William

PS. As you can see in messages.txt.  The server clock seems a bit messed
up.  It always boot with the incorrect time and after I fix it in the
operating system it always get screwed after a reboot.



------_=_NextPart_000_01C57668.18116259
Content-Type: text/plain;
	name="lspci-2005-06-20.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lspci-2005-06-20.txt"

00:00.0 Host bridge: IBM X-Architecture Bridge [Summit] (rev 05)
	Flags: bus master, 66Mhz, slow devsel, latency 240
	Capabilities: [60] PCI-X non-bridge device.

00:04.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY =
[Radeon 7000/VE] (prog-if 00 [VGA])
	Subsystem: IBM: Unknown device 029a
	Flags: bus master, stepping, medium devsel, latency 240, IRQ 3
	Memory at e0000000 (32-bit, prefetchable) [size=3D128M]
	I/O ports at 1800 [size=3D256]
	Memory at f0a20000 (32-bit, non-prefetchable) [size=3D64K]
	Capabilities: [50] Power Management version 2

00:05.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super =
South] (rev 40)
	Flags: bus master, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2

00:05.1 IDE interface: VIA Technologies, Inc. =
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) =
(prog-if 8a [Master SecP PriP])
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, medium devsel, latency 240
	I/O ports at 0700 [size=3D16]
	Capabilities: [c0] Power Management version 2

00:05.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 =
Controller (rev 1a) (prog-if 00 [UHCI])
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, medium devsel, latency 240, IRQ 225
	I/O ports at 1900 [size=3D32]
	Capabilities: [80] Power Management version 2

00:05.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 =
Controller (rev 1a) (prog-if 00 [UHCI])
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, medium devsel, latency 240, IRQ 225
	I/O ports at 1920 [size=3D32]
	Capabilities: [80] Power Management version 2

00:05.4 SMBus: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev =
40)
	Subsystem: IBM: Unknown device 02a6
	Flags: medium devsel
	Capabilities: [68] Power Management version 2

01:00.0 Host bridge: IBM X-Architecture Bridge [Summit] (rev 05)
	Flags: bus master, 66Mhz, slow devsel, latency 240
	Capabilities: [60] PCI-X non-bridge device.

01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 =
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, 66Mhz, medium devsel, latency 240, IRQ 193
	I/O ports at 2000 [size=3D256]
	Memory at f0b00000 (64-bit, non-prefetchable) [size=3D64K]
	Memory at f0b10000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable-
	Capabilities: [68] PCI-X non-bridge device.

01:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 =
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, 66Mhz, medium devsel, latency 240, IRQ 201
	I/O ports at 2100 [size=3D256]
	Memory at f0b20000 (64-bit, non-prefetchable) [size=3D64K]
	Memory at f0b30000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable-
	Capabilities: [68] PCI-X non-bridge device.

01:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 =
Gigabit Ethernet (rev 02)
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 217
	Memory at f0b40000 (64-bit, non-prefetchable) [size=3D64K]
	Memory at f0b50000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [40] PCI-X non-bridge device.
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/3 =
Enable-

01:04.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 =
Gigabit Ethernet (rev 02)
	Subsystem: IBM: Unknown device 02a6
	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 11
	Memory at f0b60000 (64-bit, non-prefetchable) [size=3D64K]
	Memory at f0b70000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [40] PCI-X non-bridge device.
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/3 =
Enable-

02:00.0 Host bridge: IBM X-Architecture Bridge [Summit] (rev 05)
	Flags: bus master, 66Mhz, slow devsel, latency 240
	Capabilities: [60] PCI-X non-bridge device.

05:00.0 Host bridge: IBM X-Architecture Bridge [Summit] (rev 05)
	Flags: bus master, 66Mhz, slow devsel, latency 240
	Capabilities: [60] PCI-X non-bridge device.

05:04.0 PCI bridge: IBM PCI-X to PCI-X Bridge (rev 02) (prog-if 00 =
[Normal decode])
	Flags: bus master, 66Mhz, medium devsel, latency 240
	Bus: primary=3D05, secondary=3D06, subordinate=3D06, sec-latency=3D240
	Memory behind bridge: f8a00000-f8afffff
	Capabilities: [80] PCI-X bridge device.
	Capabilities: [90] Power Management version 2

06:08.0 RAID bus controller: Adaptec ServeRAID Controller (rev 02)
	Subsystem: IBM ServeRAID-xx
	Flags: bus master, stepping, fast Back2Back, 66Mhz, medium devsel, =
latency 240, IRQ 209
	Memory at f8a80000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [c0] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=3D0/1 =
Enable-
	Capabilities: [e0] PCI-X non-bridge device.

07:00.0 Host bridge: IBM X-Architecture Bridge [Summit] (rev 05)
	Flags: bus master, 66Mhz, slow devsel, latency 240
	Capabilities: [60] PCI-X non-bridge device.

07:03.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev =
02)
	Subsystem: QLogic Corp.: Unknown device 0100
	Flags: bus master, 66Mhz, medium devsel, latency 128, IRQ 177
	I/O ports at 6000 [size=3D256]
	Memory at f8b20000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [4c] PCI-X non-bridge device.
	Capabilities: [54] Message Signalled Interrupts: 64bit+ Queue=3D0/3 =
Enable-
	Capabilities: [64] #06 [0080]

09:00.0 Host bridge: IBM X-Architecture Bridge [Summit] (rev 05)
	Flags: bus master, 66Mhz, slow devsel, latency 240
	Capabilities: [60] PCI-X non-bridge device.

09:02.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev =
02)
	Subsystem: QLogic Corp.: Unknown device 0100
	Flags: bus master, 66Mhz, medium devsel, latency 128, IRQ 185
	I/O ports at 9000 [size=3D256]
	Memory at f8420000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [44] Power Management version 2
	Capabilities: [4c] PCI-X non-bridge device.
	Capabilities: [54] Message Signalled Interrupts: 64bit+ Queue=3D0/3 =
Enable-
	Capabilities: [64] #06 [0080]


------_=_NextPart_000_01C57668.18116259
Content-Type: text/plain;
	name="messages-2005-06-20.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="messages-2005-06-20.txt"

Jun 20 17:20:01 dnccor50 crond(pam_unix)[11425]: session opened for =
user root by (uid=3D0)
Jun 20 17:20:01 dnccor50 crond(pam_unix)[11425]: session closed for =
user root
Jun 20 17:30:01 dnccor50 crond(pam_unix)[13060]: session opened for =
user root by (uid=3D0)
Jun 20 17:30:01 dnccor50 crond(pam_unix)[13060]: session closed for =
user root
Jun 20 17:40:01 dnccor50 crond(pam_unix)[14804]: session opened for =
user root by (uid=3D0)
Jun 20 17:40:01 dnccor50 crond(pam_unix)[14804]: session closed for =
user root
Jun 20 17:50:01 dnccor50 crond(pam_unix)[16209]: session opened for =
user root by (uid=3D0)
Jun 20 17:50:01 dnccor50 crond(pam_unix)[16209]: session closed for =
user root
Jun 20 13:34:55 dnccor50 syslogd 1.4.1: restart.
Jun 20 13:34:55 dnccor50 syslog: syslogd startup succeeded
Jun 20 13:34:55 dnccor50 syslog: klogd startup succeeded
Jun 20 13:34:55 dnccor50 kernel: klogd 1.4.1, log source =3D /proc/kmsg =
started.
Jun 20 13:34:55 dnccor50 kernel: Linux version 2.6.10-1.770_FC3smp =
(bhcompile@porky.build.redhat.com) (gcc version 3.4.2 20041017 (Red Hat =
3.4.2-6.fc3)) #1 SMP Thu Feb 24 14:20:06 EST 2005
Jun 20 13:34:55 dnccor50 kernel: BIOS-provided physical RAM map:
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 0000000000000000 - =
000000000009b000 (usable)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 000000000009b000 - =
00000000000a0000 (reserved)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 00000000000e0000 - =
0000000000100000 (reserved)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 0000000000100000 - =
00000000dff91800 (usable)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 00000000dff91800 - =
00000000dff9c340 (ACPI data)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 00000000dff9c340 - =
00000000e0000000 (reserved)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 00000000fec00000 - =
0000000100000000 (reserved)
Jun 20 13:34:55 dnccor50 kernel:  BIOS-e820: 0000000100000000 - =
00000004a0000000 (usable)
Jun 20 13:34:55 dnccor50 kernel: 18048MB HIGHMEM available.
Jun 20 13:34:55 dnccor50 kernel: 896MB LOWMEM available.
Jun 20 13:34:55 dnccor50 kernel: found SMP MP-table at 0009b140
Jun 20 13:34:55 dnccor50 kernel: Using x86 segment limits to =
approximate NX protection
Jun 20 13:34:55 dnccor50 irqbalance: irqbalance startup succeeded
Jun 20 13:34:55 dnccor50 kernel: DMI 2.3 present.
Jun 20 13:34:55 dnccor50 kernel: Using APIC driver default
Jun 20 13:34:55 dnccor50 kernel: ACPI: PM-Timer IO Port: 0x508
Jun 20 13:34:55 dnccor50 rc: Starting lm_sensors:  succeeded
Jun 20 13:34:55 dnccor50 kernel: Switched to APIC driver `summit'.
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x00] =
lapic_id[0x00] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #0 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x01] =
lapic_id[0x02] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #2 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x04] =
lapic_id[0x10] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #16 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x05] =
lapic_id[0x12] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #18 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x08] =
lapic_id[0x20] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #32 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x09] =
lapic_id[0x22] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #34 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x0c] =
lapic_id[0x30] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #48 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x0d] =
lapic_id[0x32] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #50 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x80] =
lapic_id[0x01] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #1 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x81] =
lapic_id[0x03] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #3 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x84] =
lapic_id[0x11] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #17 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x85] =
lapic_id[0x13] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #19 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x88] =
lapic_id[0x21] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #33 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 mDNSResponder:  startup succeeded
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x89] =
lapic_id[0x23] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #35 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x8c] =
lapic_id[0x31] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #49 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC (acpi_id[0x8d] =
lapic_id[0x33] enabled)
Jun 20 13:34:55 dnccor50 kernel: Processor #51 15:2 APIC version 20
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl =
lint[0x1])
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl =
lint[0x1])
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl =
lint[0x1])
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl =
lint[0x1])
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x08] dfl dfl =
lint[0x1])
Jun 20 13:34:55 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x09] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x0c] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x0d] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x80] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 sshd:  succeeded
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x81] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x84] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x85] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x88] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x89] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x8c] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: LAPIC_NMI (acpi_id[0x8d] dfl dfl =
lint[0x1])
Jun 20 13:34:56 dnccor50 kernel: ACPI: IOAPIC (id[0x0e] =
address[0xfec00000] gsi_base[0])
Jun 20 13:34:56 dnccor50 xinetd: xinetd startup succeeded
Jun 20 13:34:56 dnccor50 kernel: IOAPIC[0]: apic_id 14, version 17, =
address 0xfec00000, GSI 0-43
Jun 20 13:34:56 dnccor50 kernel: ACPI: IOAPIC (id[0x0d] =
address[0xfec01000] gsi_base[44])
Jun 20 13:34:56 dnccor50 vsftpd: vsftpd vsftpd succeeded
Jun 20 13:34:56 dnccor50 kernel: IOAPIC[1]: apic_id 13, version 17, =
address 0xfec01000, GSI 44-87
Jun 20 13:34:56 dnccor50 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 8 =
global_irq 8 low edge)
Jun 20 13:34:56 dnccor50 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 14 =
global_irq 14 high dfl)
Jun 20 13:34:56 dnccor50 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 11 =
global_irq 11 low level)
Jun 20 13:34:56 dnccor50 kernel: Enabling APIC mode:  Summit.  Using 2 =
I/O APICs
Jun 20 13:34:56 dnccor50 kernel: Using ACPI (MADT) for SMP =
configuration information
Jun 20 13:34:56 dnccor50 kernel: Built 1 zonelists
Jun 20 13:34:56 dnccor50 kernel: Kernel command line: ro =
root=3DLABEL=3D/1 rhgb quiet
Jun 20 13:34:56 dnccor50 kernel: Initializing CPU#0
Jun 20 13:34:56 dnccor50 kernel: CPU 0 irqstacks, hard=3Dc03ca000 =
soft=3Dc03aa000
Jun 20 13:34:56 dnccor50 kernel: PID hash table entries: 4096 (order: =
12, 65536 bytes)
Jun 20 13:34:56 dnccor50 kernel: Summit chipset: Starting Cyclone =
Counter.
Jun 20 13:34:56 dnccor50 kernel: Detected 2197.783 MHz processor.
Jun 20 13:34:56 dnccor50 kernel: Using cyclone for high-res timesource
Jun 20 13:34:56 dnccor50 kernel: Console: colour VGA+ 80x25
Jun 20 13:34:56 dnccor50 kernel: Dentry cache hash table entries: =
131072 (order: 7, 524288 bytes)
Jun 20 13:34:56 dnccor50 kernel: Inode-cache hash table entries: 65536 =
(order: 6, 262144 bytes)
Jun 20 13:34:56 dnccor50 sendmail: sendmail startup succeeded
Jun 20 13:34:56 dnccor50 kernel: Memory: 18714932k/19398656k available =
(1780k kernel code, 158072k reserved, 718k data, 204k init, 17956420k =
highmem)
Jun 20 13:34:56 dnccor50 kernel: Checking if this processor honours the =
WP bit even in supervisor mode... Ok.
Jun 20 13:34:56 dnccor50 kernel: Security Framework v1.0.0 initialized
Jun 20 13:34:56 dnccor50 kernel: SELinux:  Initializing.
Jun 20 13:34:56 dnccor50 sendmail: sm-client startup succeeded
Jun 20 13:34:56 dnccor50 kernel: SELinux:  Starting in permissive mode
Jun 20 13:34:56 dnccor50 kernel: selinux_register_security:  =
Registering secondary module capability
Jun 20 13:34:56 dnccor50 kernel: Capability LSM initialized as =
secondary
Jun 20 13:34:56 dnccor50 kernel: Mount-cache hash table entries: 512 =
(order: 0, 4096 bytes)
Jun 20 13:34:56 dnccor50 gpm[4169]: *** info [startup.c(95)]:=20
Jun 20 13:34:56 dnccor50 gpm[4169]: Started gpm successfully. Entered =
daemon mode.
Jun 20 13:34:56 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:56 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:57 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:57 dnccor50 kernel: CPU: Physical Processor ID: 0
Jun 20 13:34:57 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:57 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#0.
Jun 20 13:34:57 dnccor50 kernel: CPU0: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:57 dnccor50 kernel: CPU0: Thermal monitoring enabled
Jun 20 13:34:57 dnccor50 kernel: Enabling fast FPU save and restore... =
done.
Jun 20 13:34:57 dnccor50 kernel: Enabling unmasked SIMD FPU exception =
support... done.
Jun 20 13:34:57 dnccor50 kernel: Checking 'hlt' instruction... OK.
Jun 20 13:34:57 dnccor50 kernel: CPU0: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:57 dnccor50 kernel: per-CPU timeslice cutoff: 1463.19 =
usecs.
Jun 20 13:34:57 dnccor50 kernel: task migration cache decay timeout: 2 =
msecs.
Jun 20 13:34:57 dnccor50 xinetd[4120]: xinetd Version 2.3.13 started =
with libwrap loadavg options compiled in.
Jun 20 13:34:57 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:57 dnccor50 kernel: Booting processor 1/2 eip 3000
Jun 20 13:34:57 dnccor50 kernel: CPU 1 irqstacks, hard=3Dc03cb000 =
soft=3Dc03ab000
Jun 20 13:34:57 dnccor50 xinetd[4120]: Started working: 1 available =
service
Jun 20 13:34:57 dnccor50 kernel: Initializing CPU#1
Jun 20 13:34:57 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:57 dnccor50 gpm[4169]: *** info [mice.c(1766)]:=20
Jun 20 13:34:57 dnccor50 gpm[4169]: imps2: Auto-detected intellimouse =
PS/2
Jun 20 13:34:57 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:57 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:57 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:57 dnccor50 kernel: CPU: Physical Processor ID: 1
Jun 20 13:34:57 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:57 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#1.
Jun 20 13:34:57 dnccor50 kernel: CPU1: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:57 dnccor50 kernel: CPU1: Thermal monitoring enabled
Jun 20 13:34:57 dnccor50 kernel: CPU1: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:57 dnccor50 kernel: Booting processor 2/16 eip 3000
Jun 20 13:34:57 dnccor50 kernel: CPU 2 irqstacks, hard=3Dc03cc000 =
soft=3Dc03ac000
Jun 20 13:34:57 dnccor50 kernel: Initializing CPU#2
Jun 20 13:34:57 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:57 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:57 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:57 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:57 dnccor50 kernel: CPU: Physical Processor ID: 8
Jun 20 13:34:57 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:57 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#2.
Jun 20 13:34:57 dnccor50 kernel: CPU2: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:57 dnccor50 kernel: CPU2: Thermal monitoring enabled
Jun 20 13:34:57 dnccor50 kernel: CPU2: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:57 dnccor50 kernel: Booting processor 3/18 eip 3000
Jun 20 13:34:57 dnccor50 kernel: CPU 3 irqstacks, hard=3Dc03cd000 =
soft=3Dc03ad000
Jun 20 13:34:57 dnccor50 kernel: Initializing CPU#3
Jun 20 13:34:57 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:57 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:57 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:57 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:57 dnccor50 kernel: CPU: Physical Processor ID: 9
Jun 20 13:34:57 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:57 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#3.
Jun 20 13:34:57 dnccor50 kernel: CPU3: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:57 dnccor50 kernel: CPU3: Thermal monitoring enabled
Jun 20 13:34:57 dnccor50 kernel: CPU3: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:57 dnccor50 kernel: Booting processor 4/32 eip 3000
Jun 20 13:34:57 dnccor50 kernel: CPU 4 irqstacks, hard=3Dc03ce000 =
soft=3Dc03ae000
Jun 20 13:34:57 dnccor50 kernel: Initializing CPU#4
Jun 20 13:34:57 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:57 dnccor50 gpm: gpm startup succeeded
Jun 20 13:34:57 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:57 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:57 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:57 dnccor50 kernel: CPU: Physical Processor ID: 16
Jun 20 13:34:57 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:57 dnccor50 crond: crond startup succeeded
Jun 20 13:34:57 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#4.
Jun 20 13:34:57 dnccor50 kernel: CPU4: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:57 dnccor50 kernel: CPU4: Thermal monitoring enabled
Jun 20 13:34:57 dnccor50 kernel: CPU4: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:23 dnccor50 rc.sysinit: -e=20
Jun 20 13:34:57 dnccor50 kernel: Booting processor 5/34 eip 3000
Jun 20 13:34:24 dnccor50 udevsend[1225]: starting udevd daemon=20
Jun 20 13:34:57 dnccor50 kernel: CPU 5 irqstacks, hard=3Dc03cf000 =
soft=3Dc03af000
Jun 20 13:34:57 dnccor50 kernel: Initializing CPU#5
Jun 20 13:34:24 dnccor50 scsi.agent[1237]: disk at =
/devices/pci0000:05/0000:05:04.0/0000:06:08.0/host4/target4:0:0/4:0:0:0 =

Jun 20 13:34:57 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:24 dnccor50 scsi.agent[1259]: processor at =
/devices/pci0000:05/0000:05:04.0/0000:06:08.0/host4/target4:0:15/4:0:15:=
0=20
Jun 20 13:34:57 dnccor50 xfs: xfs startup succeeded
Jun 20 13:34:57 dnccor50 xfs[4206]: ignoring font path element =
/usr/X11R6/lib/X11/fonts/Speedo (unreadable)=20
Jun 20 13:34:25 dnccor50 scsi.agent[1355]: processor at =
/devices/pci0000:05/0000:05:04.0/0000:06:08.0/host4/target4:1:8/4:1:8:0 =

Jun 20 13:34:25 dnccor50 scsi.agent[1410]: disk at =
/devices/pci0000:07/0000:07:03.0/host0/target0:0:0/0:0:0:2=20
Jun 20 13:34:25 dnccor50 scsi.agent[1451]: disk at =
/devices/pci0000:07/0000:07:03.0/host0/target0:0:1/0:0:1:2=20
Jun 20 13:34:58 dnccor50 anacron: anacron startup succeeded
Jun 20 13:34:58 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:26 dnccor50 start_udev: Starting udev:  succeeded=20
Jun 20 13:34:58 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:28 dnccor50 udevsend[1946]: starting udevd daemon=20
Jun 20 13:34:58 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:58 dnccor50 kernel: CPU: Physical Processor ID: 17
Jun 20 13:34:58 dnccor50 atd: atd startup succeeded
Jun 20 13:34:28 dnccor50 udevsend[1947]: starting udevd daemon=20
Jun 20 13:34:58 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:28 dnccor50 rc.sysinit: -e=20
Jun 20 13:34:58 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#5.
Jun 20 13:34:29 dnccor50 sysctl: net.ipv4.ip_forward =3D 0=20
Jun 20 13:34:58 dnccor50 kernel: CPU5: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:29 dnccor50 sysctl: net.ipv4.conf.default.rp_filter =3D 1=20
Jun 20 13:34:58 dnccor50 messagebus: messagebus startup succeeded
Jun 20 13:34:58 dnccor50 kernel: CPU5: Thermal monitoring enabled
Jun 20 13:34:29 dnccor50 sysctl: =
net.ipv4.conf.default.accept_source_route =3D 0=20
Jun 20 13:34:58 dnccor50 kernel: CPU5: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:58 dnccor50 kernel: Booting processor 6/48 eip 3000
Jun 20 13:34:58 dnccor50 kernel: CPU 6 irqstacks, hard=3Dc03d0000 =
soft=3Dc03b0000
Jun 20 13:34:29 dnccor50 sysctl: kernel.sysrq =3D 0=20
Jun 20 13:34:58 dnccor50 kernel: Initializing CPU#6
Jun 20 13:34:29 dnccor50 sysctl: kernel.core_uses_pid =3D 1=20
Jun 20 13:34:58 dnccor50 haldaemon: haldaemon startup succeeded
Jun 20 13:34:58 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:29 dnccor50 sysctl: kernel.shmmax =3D 2147483648=20
Jun 20 13:34:58 dnccor50 fstab-sync[4247]: removed all generated mount =
points
Jun 20 13:34:29 dnccor50 sysctl: kernel.sem =3D 820 104960 820 128=20
Jun 20 13:34:29 dnccor50 sysctl: fs.file-max =3D 131072=20
Jun 20 13:34:29 dnccor50 sysctl: net.ipv4.ip_local_port_range =3D 1024 =
65000=20
Jun 20 13:34:58 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:29 dnccor50 rc.sysinit: Configuring kernel parameters:  =
succeeded=20
Jun 20 13:34:58 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:34 dnccor50 date: Mon Jun 20 13:34:34 COT 2005=20
Jun 20 13:34:58 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:34 dnccor50 rc.sysinit: Setting clock  (localtime): Mon =
Jun 20 13:34:34 COT 2005 succeeded=20
Jun 20 13:34:58 dnccor50 kernel: CPU: Physical Processor ID: 24
Jun 20 13:34:34 dnccor50 rc.sysinit: Loading default keymap succeeded=20
Jun 20 13:34:34 dnccor50 rc.sysinit: Setting hostname dnccor50:  =
succeeded=20
Jun 20 13:34:58 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:39 dnccor50 fsck: /1: clean, 132795/6540800 files, =
3720500/13080926 blocks=20
Jun 20 13:34:58 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#6.
Jun 20 13:34:39 dnccor50 rc.sysinit: Checking root filesystem succeeded =

Jun 20 13:34:58 dnccor50 kernel: CPU6: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:39 dnccor50 rc.sysinit: Remounting root filesystem in =
read-write mode:  succeeded=20
Jun 20 13:34:58 dnccor50 kernel: CPU6: Thermal monitoring enabled
Jun 20 13:34:40 dnccor50 lvm.static:   No volume groups found=20
Jun 20 13:34:58 dnccor50 kernel: CPU6: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:40 dnccor50 rc.sysinit: Setting up Logical Volume =
Management: succeeded=20
Jun 20 13:34:58 dnccor50 kernel: Booting processor 7/50 eip 3000
Jun 20 13:34:40 dnccor50 fsck: /boot: recovering journal=20
Jun 20 13:34:58 dnccor50 kernel: CPU 7 irqstacks, hard=3Dc03d1000 =
soft=3Dc03b1000
Jun 20 13:34:40 dnccor50 fsck: /boot: clean, 45/56224 files, =
24728/224876 blocks=20
Jun 20 13:34:59 dnccor50 kernel: Initializing CPU#7
Jun 20 13:34:40 dnccor50 fsck: /ubas: recovering journal=20
Jun 20 13:34:59 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:44 dnccor50 fsck: /ubas: clean, 309/10485760 files, =
18339188/20970841 blocks=20
Jun 20 13:34:44 dnccor50 rc.sysinit: Checking filesystems succeeded=20
Jun 20 13:34:44 dnccor50 rc.sysinit: Mounting local filesystems:  =
succeeded=20
Jun 20 13:34:44 dnccor50 rc.sysinit: Enabling local filesystem quotas:  =
succeeded=20
Jun 20 13:34:59 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:44 dnccor50 rc.sysinit: Enabling swap space:  succeeded=20
Jun 20 13:34:59 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:44 dnccor50 init: Entering runlevel: 3=20
Jun 20 13:34:59 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:44 dnccor50 sysstat: Calling the system activity data =
collector (sadc): =20
Jun 20 13:34:59 dnccor50 kernel: CPU: Physical Processor ID: 25
Jun 20 13:34:45 dnccor50 sysstat: =20
Jun 20 13:34:45 dnccor50 rc: Starting sysstat:  succeeded=20
Jun 20 13:34:50 dnccor50 kudzu:  succeeded=20
Jun 20 13:34:50 dnccor50 rc: Starting pcmcia:  succeeded=20
Jun 20 13:34:50 dnccor50 sysctl: net.ipv4.ip_forward =3D 0=20
Jun 20 13:34:50 dnccor50 sysctl: net.ipv4.conf.default.rp_filter =3D 1=20
Jun 20 13:34:59 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:50 dnccor50 sysctl: =
net.ipv4.conf.default.accept_source_route =3D 0=20
Jun 20 13:34:59 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#7.
Jun 20 13:34:50 dnccor50 sysctl: kernel.sysrq =3D 0=20
Jun 20 13:34:59 dnccor50 kernel: CPU7: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:50 dnccor50 sysctl: kernel.core_uses_pid =3D 1=20
Jun 20 13:34:59 dnccor50 kernel: CPU7: Thermal monitoring enabled
Jun 20 13:34:50 dnccor50 sysctl: kernel.shmmax =3D 2147483648=20
Jun 20 13:34:59 dnccor50 kernel: CPU7: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:50 dnccor50 sysctl: kernel.sem =3D 820 104960 820 128=20
Jun 20 13:34:59 dnccor50 kernel: Booting processor 8/1 eip 3000
Jun 20 13:34:50 dnccor50 sysctl: fs.file-max =3D 131072=20
Jun 20 13:34:59 dnccor50 kernel: CPU 8 irqstacks, hard=3Dc03d2000 =
soft=3Dc03b2000
Jun 20 13:34:50 dnccor50 sysctl: net.ipv4.ip_local_port_range =3D 1024 =
65000=20
Jun 20 13:34:59 dnccor50 kernel: Initializing CPU#8
Jun 20 13:34:50 dnccor50 network: Setting network parameters:  =
succeeded=20
Jun 20 13:34:59 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:50 dnccor50 network: Bringing up loopback interface:  =
succeeded=20
Jun 20 13:34:52 dnccor50 network: Bringing up interface eth0:  =
succeeded=20
Jun 20 13:34:55 dnccor50 network: Bringing up interface eth1:  =
succeeded=20
Jun 20 13:34:59 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:59 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:59 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:59 dnccor50 kernel: CPU: Physical Processor ID: 0
Jun 20 13:34:59 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:59 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#8.
Jun 20 13:34:59 dnccor50 kernel: CPU8: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:59 dnccor50 kernel: CPU8: Thermal monitoring enabled
Jun 20 13:34:59 dnccor50 kernel: CPU8: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:59 dnccor50 kernel: Booting processor 9/3 eip 3000
Jun 20 13:34:59 dnccor50 kernel: CPU 9 irqstacks, hard=3Dc03d3000 =
soft=3Dc03b3000
Jun 20 13:34:59 dnccor50 kernel: Initializing CPU#9
Jun 20 13:34:59 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:59 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:59 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:59 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:59 dnccor50 kernel: CPU: Physical Processor ID: 1
Jun 20 13:34:59 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:59 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#9.
Jun 20 13:34:59 dnccor50 kernel: CPU9: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:59 dnccor50 kernel: CPU9: Thermal monitoring enabled
Jun 20 13:34:59 dnccor50 kernel: CPU9: Intel(R) Xeon(TM) MP CPU 2.20GHz =
stepping 06
Jun 20 13:34:59 dnccor50 kernel: Booting processor 10/17 eip 3000
Jun 20 13:34:59 dnccor50 kernel: CPU 10 irqstacks, hard=3Dc03d4000 =
soft=3Dc03b4000
Jun 20 13:34:59 dnccor50 kernel: Initializing CPU#10
Jun 20 13:34:59 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:59 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:59 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:59 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:59 dnccor50 kernel: CPU: Physical Processor ID: 8
Jun 20 13:34:59 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:59 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#10.
Jun 20 13:34:59 dnccor50 kernel: CPU10: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:59 dnccor50 kernel: CPU10: Thermal monitoring enabled
Jun 20 13:34:59 dnccor50 kernel: CPU10: Intel(R) Xeon(TM) MP CPU =
2.20GHz stepping 06
Jun 20 13:34:59 dnccor50 kernel: Booting processor 11/19 eip 3000
Jun 20 13:34:59 dnccor50 kernel: CPU 11 irqstacks, hard=3Dc03d5000 =
soft=3Dc03b5000
Jun 20 13:34:59 dnccor50 kernel: Initializing CPU#11
Jun 20 13:34:59 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:59 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:59 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:59 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:59 dnccor50 kernel: CPU: Physical Processor ID: 9
Jun 20 13:34:59 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:34:59 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#11.
Jun 20 13:34:59 dnccor50 kernel: CPU11: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:34:59 dnccor50 kernel: CPU11: Thermal monitoring enabled
Jun 20 13:34:59 dnccor50 fstab-sync[4680]: added mount point =
/media/cdrom for /dev/hda
Jun 20 13:34:59 dnccor50 kernel: CPU11: Intel(R) Xeon(TM) MP CPU =
2.20GHz stepping 06
Jun 20 13:34:59 dnccor50 kernel: Booting processor 12/33 eip 3000
Jun 20 13:34:59 dnccor50 kernel: CPU 12 irqstacks, hard=3Dc03d6000 =
soft=3Dc03b6000
Jun 20 13:34:59 dnccor50 kernel: Initializing CPU#12
Jun 20 13:34:59 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:34:59 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:34:59 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:34:59 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:34:59 dnccor50 kernel: CPU: Physical Processor ID: 16
Jun 20 13:35:00 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:35:00 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#12.
Jun 20 13:35:00 dnccor50 kernel: CPU12: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:35:00 dnccor50 kernel: CPU12: Thermal monitoring enabled
Jun 20 13:35:00 dnccor50 kernel: CPU12: Intel(R) Xeon(TM) MP CPU =
2.20GHz stepping 06
Jun 20 13:35:00 dnccor50 kernel: Booting processor 13/35 eip 3000
Jun 20 13:35:00 dnccor50 kernel: CPU 13 irqstacks, hard=3Dc03d7000 =
soft=3Dc03b7000
Jun 20 13:35:00 dnccor50 kernel: Initializing CPU#13
Jun 20 13:35:00 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:35:00 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:35:00 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:35:00 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:35:00 dnccor50 kernel: CPU: Physical Processor ID: 17
Jun 20 13:35:00 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:35:00 dnccor50 fstab-sync[4698]: added mount point =
/media/floppy for /dev/fd0
Jun 20 13:35:00 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#13.
Jun 20 13:35:00 dnccor50 kernel: CPU13: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:35:00 dnccor50 kernel: CPU13: Thermal monitoring enabled
Jun 20 13:35:00 dnccor50 kernel: CPU13: Intel(R) Xeon(TM) MP CPU =
2.20GHz stepping 06
Jun 20 13:35:00 dnccor50 kernel: Booting processor 14/49 eip 3000
Jun 20 13:35:00 dnccor50 kernel: CPU 14 irqstacks, hard=3Dc03d8000 =
soft=3Dc03b8000
Jun 20 13:35:00 dnccor50 kernel: Initializing CPU#14
Jun 20 13:35:00 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:35:00 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:35:00 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:35:00 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:35:00 dnccor50 kernel: CPU: Physical Processor ID: 24
Jun 20 13:35:00 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:35:00 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#14.
Jun 20 13:35:00 dnccor50 kernel: CPU14: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:35:00 dnccor50 kernel: CPU14: Thermal monitoring enabled
Jun 20 13:35:00 dnccor50 kernel: CPU14: Intel(R) Xeon(TM) MP CPU =
2.20GHz stepping 06
Jun 20 13:35:00 dnccor50 kernel: Booting processor 15/51 eip 3000
Jun 20 13:35:00 dnccor50 kernel: CPU 15 irqstacks, hard=3Dc03d9000 =
soft=3Dc03b9000
Jun 20 13:35:00 dnccor50 kernel: Initializing CPU#15
Jun 20 13:35:00 dnccor50 kernel: Leaving ESR disabled.
Jun 20 13:35:00 dnccor50 kernel: CPU: Trace cache: 12K uops, L1 D =
cache: 8K
Jun 20 13:35:00 dnccor50 kernel: CPU: L2 cache: 512K
Jun 20 13:35:00 dnccor50 kernel: CPU: L3 cache: 2048K
Jun 20 13:35:00 dnccor50 kernel: CPU: Physical Processor ID: 25
Jun 20 13:35:00 dnccor50 kernel: Intel machine check architecture =
supported.
Jun 20 13:35:00 dnccor50 kernel: Intel machine check reporting enabled =
on CPU#15.
Jun 20 13:35:00 dnccor50 kernel: CPU15: Intel P4/Xeon Extended MCE MSRs =
(12) available
Jun 20 13:35:00 dnccor50 kernel: CPU15: Thermal monitoring enabled
Jun 20 13:35:00 dnccor50 kernel: CPU15: Intel(R) Xeon(TM) MP CPU =
2.20GHz stepping 06
Jun 20 13:35:00 dnccor50 kernel: Total of 16 processors activated =
(3180.54 BogoMIPS).
Jun 20 13:35:00 dnccor50 kernel: ENABLING IO-APIC IRQs
Jun 20 13:35:00 dnccor50 kernel: ..TIMER: vector=3D0x31 pin1=3D0 =
pin2=3D-1
Jun 20 13:35:00 dnccor50 kernel: checking TSC synchronization across 16 =
CPUs:=20
Jun 20 13:35:00 dnccor50 kernel: CPU#0 had 1467586 usecs TSC skew, =
fixed it up.
Jun 20 13:35:00 dnccor50 kernel: CPU#1 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#2 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#3 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#4 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#5 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#6 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#7 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#8 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#9 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#10 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#11 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#12 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#13 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#14 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: CPU#15 had 0 usecs TSC skew, fixed it =
up.
Jun 20 13:35:00 dnccor50 kernel: Brought up 16 CPUs
Jun 20 13:35:00 dnccor50 kernel: checking if image is initramfs... it =
is
Jun 20 13:35:00 dnccor50 kernel: Freeing initrd memory: 617k freed
Jun 20 13:35:00 dnccor50 kernel: NET: Registered protocol family 16
Jun 20 13:35:00 dnccor50 kernel: PCI: PCI BIOS revision 2.10 entry at =
0xfd47d, last bus=3D11
Jun 20 13:35:00 dnccor50 kernel: PCI: Using configuration type 1
Jun 20 13:35:00 dnccor50 kernel: mtrr: v2.0 (20020519)
Jun 20 13:35:00 dnccor50 kernel: ACPI: Subsystem revision 20041105
Jun 20 13:35:00 dnccor50 kernel: ACPI: Interpreter enabled
Jun 20 13:35:00 dnccor50 kernel: ACPI: Using IOAPIC for interrupt =
routing
Jun 20 13:35:00 dnccor50 kernel: ACPI: PCI Root Bridge [VP00] (00:00)
Jun 20 13:35:00 dnccor50 kernel: PCI: Probing PCI hardware (bus 00)
Jun 20 13:35:00 dnccor50 kernel: ACPI: PCI Root Bridge [VP01] (00:01)
Jun 20 13:35:00 dnccor50 kernel: PCI: Probing PCI hardware (bus 01)
Jun 20 13:35:00 dnccor50 kernel: ACPI: PCI Root Bridge [VP02] (00:02)
Jun 20 13:35:00 dnccor50 kernel: PCI: Probing PCI hardware (bus 02)
Jun 20 13:35:00 dnccor50 kernel: ACPI: PCI Root Bridge [VP03] (00:05)
Jun 20 13:35:00 dnccor50 kernel: PCI: Probing PCI hardware (bus 05)
Jun 20 13:35:00 dnccor50 kernel: ACPI: PCI Root Bridge [VP04] (00:07)
Jun 20 13:35:00 dnccor50 kernel: PCI: Probing PCI hardware (bus 07)
Jun 20 13:35:00 dnccor50 kernel: ACPI: PCI Root Bridge [VP05] (00:09)
Jun 20 13:35:00 dnccor50 kernel: PCI: Probing PCI hardware (bus 09)
Jun 20 13:35:00 dnccor50 kernel: Linux Plug and Play Support v0.97 (c) =
Adam Belay
Jun 20 13:35:00 dnccor50 kernel: pnp: PnP ACPI init
Jun 20 13:35:00 dnccor50 kernel: pnp: PnP ACPI: found 16 devices
Jun 20 13:35:00 dnccor50 kernel: usbcore: registered new driver usbfs
Jun 20 13:35:00 dnccor50 kernel: usbcore: registered new driver hub
Jun 20 13:35:00 dnccor50 kernel: PCI: Using ACPI for IRQ routing
Jun 20 13:35:00 dnccor50 kernel: ** PCI interrupts are no longer routed =
automatically.  If this
Jun 20 13:35:00 dnccor50 kernel: ** causes a device to stop working, it =
is probably because the
Jun 20 13:35:00 dnccor50 kernel: ** driver failed to call =
pci_enable_device().  As a temporary
Jun 20 13:35:00 dnccor50 kernel: ** workaround, the "pci=3Drouteirq" =
argument restores the old
Jun 20 13:35:00 dnccor50 kernel: ** behavior.  If this argument makes =
the device work again,
Jun 20 13:35:00 dnccor50 kernel: ** please email the output of "lspci" =
to bjorn.helgaas@hp.com
Jun 20 13:35:00 dnccor50 kernel: ** so I can fix the driver.
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:01: ioport range 0x430-0x437 =
has been reserved
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:01: ioport range 0x438-0x439 =
has been reserved
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:0b: ioport range 0x440-0x44f =
has been reserved
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:0b: ioport range 0x4c0-0x4c3 =
has been reserved
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:0b: ioport range 0x4d0-0x4d1 =
has been reserved
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:0b: ioport range 0x4e0-0x4ff =
could not be reserved
Jun 20 13:35:00 dnccor50 kernel: pnp: 00:0b: ioport range 0x500-0x57f =
could not be reserved
Jun 20 13:35:00 dnccor50 kernel: IBM machine detected. Enabling =
interrupts during APM calls.
Jun 20 13:35:00 dnccor50 kernel: apm: BIOS not found.
Jun 20 13:35:00 dnccor50 kernel: audit: initializing netlink socket =
(disabled)
Jun 20 13:35:00 dnccor50 kernel: audit(1119292429.249:0): initialized
Jun 20 13:35:00 dnccor50 kernel: highmem bounce pool size: 64 pages
Jun 20 13:35:00 dnccor50 kernel: Total HugeTLB memory allocated, 0
Jun 20 13:35:00 dnccor50 kernel: VFS: Disk quotas dquot_6.5.1
Jun 20 13:35:00 dnccor50 kernel: Dquot-cache hash table entries: 1024 =
(order 0, 4096 bytes)
Jun 20 13:35:00 dnccor50 kernel: SELinux:  Registering netfilter hooks
Jun 20 13:35:00 dnccor50 kernel: Initializing Cryptographic API
Jun 20 13:35:00 dnccor50 kernel: ksign: Installing public key data
Jun 20 13:35:00 dnccor50 kernel: Loading keyring
Jun 20 13:35:00 dnccor50 kernel: - Added public key C1F2FA57F7EECD64
Jun 20 13:35:00 dnccor50 kernel: - User ID: Red Hat, Inc. (Kernel =
Module GPG key)
Jun 20 13:35:00 dnccor50 kernel: PCI: Enabling Via external APIC =
routing
Jun 20 13:35:00 dnccor50 kernel: pci_hotplug: PCI Hot Plug PCI Core =
version: 0.5
Jun 20 13:35:00 dnccor50 kernel: isapnp: Scanning for PnP cards...
Jun 20 13:35:00 dnccor50 kernel: isapnp: No Plug & Play device found
Jun 20 13:35:00 dnccor50 kernel: Real Time Clock Driver v1.12
Jun 20 13:35:00 dnccor50 kernel: Linux agpgart interface v0.100 (c) =
Dave Jones
Jun 20 13:35:00 dnccor50 kernel: serio: i8042 AUX port at 0x60,0x64 irq =
12
Jun 20 13:35:00 dnccor50 kernel: serio: i8042 KBD port at 0x60,0x64 irq =
1
Jun 20 13:35:00 dnccor50 kernel: Serial: 8250/16550 driver $Revision: =
1.90 $ 76 ports, IRQ sharing enabled
Jun 20 13:35:00 dnccor50 kernel: ttyS0 at I/O 0x3f8 (irq =3D 4) is a =
16550A
Jun 20 13:35:00 dnccor50 kernel: ttyS0 at I/O 0x3f8 (irq =3D 4) is a =
16550A
Jun 20 13:35:00 dnccor50 kernel: io scheduler noop registered
Jun 20 13:35:00 dnccor50 kernel: io scheduler anticipatory registered
Jun 20 13:35:00 dnccor50 kernel: io scheduler deadline registered
Jun 20 13:35:00 dnccor50 kernel: io scheduler cfq registered
Jun 20 13:35:00 dnccor50 kernel: RAMDISK driver initialized: 16 RAM =
disks of 16384K size 1024 blocksize
Jun 20 13:35:00 dnccor50 kernel: Uniform Multi-Platform E-IDE driver =
Revision: 7.00alpha2
Jun 20 13:35:00 dnccor50 kernel: ide: Assuming 33MHz system bus speed =
for PIO modes; override with idebus=3Dxx
Jun 20 13:35:00 dnccor50 kernel: VP_IDE: IDE controller at PCI slot =
0000:00:05.1
Jun 20 13:35:01 dnccor50 kernel: VP_IDE: chipset revision 6
Jun 20 13:35:01 dnccor50 kernel: VP_IDE: not 100% native mode: will =
probe irqs later
Jun 20 13:35:01 dnccor50 kernel: VP_IDE: VIA vt82c686b (rev 40) IDE =
UDMA100 controller on pci0000:00:05.1
Jun 20 13:35:01 dnccor50 kernel:     ide0: BM-DMA at 0x0700-0x0707, =
BIOS settings: hda:pio, hdb:pio
Jun 20 13:35:01 dnccor50 kernel:     ide1: BM-DMA at 0x0708-0x070f, =
BIOS settings: hdc:pio, hdd:pio
Jun 20 13:35:01 dnccor50 kernel: hda: MATSHITADVD-ROM SR-8177, ATAPI =
CD/DVD-ROM drive
Jun 20 13:35:01 dnccor50 kernel: elevator: using anticipatory as =
default io scheduler
Jun 20 13:35:01 dnccor50 kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Jun 20 13:35:01 dnccor50 kernel: hda: ATAPI 24X DVD-ROM drive, 256kB =
Cache, UDMA(33)
Jun 20 13:35:01 dnccor50 kernel: Uniform CD-ROM driver Revision: 3.20
Jun 20 13:35:01 dnccor50 kernel: ide-floppy driver 0.99.newide
Jun 20 13:35:01 dnccor50 kernel: usbcore: registered new driver hiddev
Jun 20 13:35:01 dnccor50 kernel: usbcore: registered new driver usbhid
Jun 20 13:35:01 dnccor50 kernel: drivers/usb/input/hid-core.c: v2.0:USB =
HID core driver
Jun 20 13:35:01 dnccor50 kernel: mice: PS/2 mouse device common for all =
mice
Jun 20 13:35:01 dnccor50 kernel: input: AT Translated Set 2 keyboard on =
isa0060/serio0
Jun 20 13:35:01 dnccor50 kernel: input: ImPS/2 Logitech Wheel Mouse on =
isa0060/serio1
Jun 20 13:35:01 dnccor50 kernel: md: md driver 0.90.1 =
MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
Jun 20 13:35:01 dnccor50 kernel: NET: Registered protocol family 2
Jun 20 13:35:01 dnccor50 kernel: IP: routing cache hash table of 131072 =
buckets, 2048Kbytes
Jun 20 13:35:01 dnccor50 kernel: TCP: Hash tables configured =
(established 262144 bind 43690)
Jun 20 13:35:01 dnccor50 kernel: Initializing IPsec netlink socket
Jun 20 13:35:01 dnccor50 kernel: NET: Registered protocol family 1
Jun 20 13:35:01 dnccor50 kernel: NET: Registered protocol family 17
Jun 20 13:35:01 dnccor50 kernel: ACPI wakeup devices:=20
Jun 20 13:35:01 dnccor50 kernel:=20
Jun 20 13:35:01 dnccor50 kernel: ACPI: (supports S0 S5)
Jun 20 13:35:01 dnccor50 kernel: Freeing unused kernel memory: 204k =
freed
Jun 20 13:35:01 dnccor50 kernel: SCSI subsystem initialized
Jun 20 13:35:01 dnccor50 kernel: QLogic Fibre Channel HBA Driver =
(f888c000)
Jun 20 13:35:01 dnccor50 kernel: ACPI: PCI interrupt 0000:07:03.0[A] -> =
GSI 60 (level, low) -> IRQ 177
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: Found an =
ISP2312, irq 177, iobase 0xf882c000
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: Configuring PCI =
space...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: Configure NVRAM =
parameters...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: Verifying loaded =
RISC code...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: LIP reset =
occured (f7f7).
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: Waiting for LIP =
to complete...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: LOOP UP detected =
(2 Gbps).
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: Topology - =
(F_Port), Host Loop address 0xffff
Jun 20 13:35:01 dnccor50 kernel: scsi0 : qla2xxx
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0:=20
Jun 20 13:35:01 dnccor50 kernel:  QLogic Fibre Channel HBA Driver: =
8.00.00b21-k
Jun 20 13:35:01 dnccor50 kernel:   QLogic QLA2340 - 133MHz PCI-X to 2Gb =
FC, Single Channel
Jun 20 13:35:01 dnccor50 kernel:   ISP2312: PCI-X (133 MHz) @ =
0000:07:03.0 hdma+, host#=3D0, fw=3D3.03.02 IPX
Jun 20 13:35:01 dnccor50 kernel: scsi: unknown device type 12
Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 =
(C)COMPAQ  Rev: 3010
Jun 20 13:35:01 dnccor50 kernel:   Type:   RAID                         =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:0:0): =
Enabled tagged queuing, queue depth 32.
Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 =
(C)COMPAQ  Rev: 2001
Jun 20 13:35:01 dnccor50 kernel:   Type:   Direct-Access                =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:0:2): =
Enabled tagged queuing, queue depth 32.
Jun 20 13:35:01 dnccor50 kernel: SCSI device sda: 167772160 512-byte =
hdwr sectors (85899 MB)
Jun 20 13:35:01 dnccor50 kernel: SCSI device sda: drive cache: write =
through
Jun 20 13:35:01 dnccor50 kernel: SCSI device sda: 167772160 512-byte =
hdwr sectors (85899 MB)
Jun 20 13:35:01 dnccor50 kernel: SCSI device sda: drive cache: write =
through
Jun 20 13:35:01 dnccor50 kernel:  sda: sda1
Jun 20 13:35:01 dnccor50 kernel: Attached scsi disk sda at scsi0, =
channel 0, id 0, lun 2
Jun 20 13:35:01 dnccor50 kernel: scsi: unknown device type 12
Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 =
(C)COMPAQ  Rev: 3010
Jun 20 13:35:01 dnccor50 kernel:   Type:   RAID                         =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:1:0): =
Enabled tagged queuing, queue depth 32.
Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 =
(C)COMPAQ  Rev: 2001
Jun 20 13:35:01 dnccor50 kernel:   Type:   Direct-Access                =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:1:2): =
Enabled tagged queuing, queue depth 32.
Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byte =
hdwr sectors (85899 MB)
Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write =
through
Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byte =
hdwr sectors (85899 MB)
Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write =
through
Jun 20 13:35:01 dnccor50 kernel:  sdb:<6>Device sdb not ready.
Jun 20 13:35:01 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:01 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:01 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:01 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:01 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:01 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:01 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:01 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:01 dnccor50 kernel:  unable to read partition table
Jun 20 13:35:01 dnccor50 kernel: Attached scsi disk sdb at scsi0, =
channel 0, id 1, lun 2
Jun 20 13:35:01 dnccor50 kernel: ACPI: PCI interrupt 0000:09:02.0[A] -> =
GSI 56 (level, low) -> IRQ 185
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0: Found an =
ISP2312, irq 185, iobase 0xf882e000
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0: Configuring PCI =
space...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0: Configure NVRAM =
parameters...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0: Verifying loaded =
RISC code...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0: Waiting for LIP =
to complete...
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0: Cable is =
unplugged...
Jun 20 13:35:01 dnccor50 kernel: scsi1 : qla2xxx
Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:09:02.0:=20
Jun 20 13:35:01 dnccor50 kernel:  QLogic Fibre Channel HBA Driver: =
8.00.00b21-k
Jun 20 13:35:01 dnccor50 kernel:   QLogic QLA2340 - 133MHz PCI-X to 2Gb =
FC, Single Channel
Jun 20 13:35:01 dnccor50 kernel:   ISP2312: PCI-X (133 MHz) @ =
0000:09:02.0 hdma+, host#=3D1, fw=3D3.03.02 IPX
Jun 20 13:35:01 dnccor50 kernel: Fusion MPT base driver 3.01.18
Jun 20 13:35:01 dnccor50 kernel: Copyright (c) 1999-2004 LSI Logic =
Corporation
Jun 20 13:35:01 dnccor50 kernel: ACPI: PCI interrupt 0000:01:03.0[A] -> =
GSI 40 (level, low) -> IRQ 193
Jun 20 13:35:01 dnccor50 kernel: mptbase: Initiating ioc0 bringup
Jun 20 13:35:01 dnccor50 kernel: ioc0: 53C1030: =
Capabilities=3D{Initiator}
Jun 20 13:35:01 dnccor50 kernel: ACPI: PCI interrupt 0000:01:03.1[B] -> =
GSI 41 (level, low) -> IRQ 201
Jun 20 13:35:01 dnccor50 kernel: mptbase: Initiating ioc1 bringup
Jun 20 13:35:01 dnccor50 kernel: ioc1: 53C1030: =
Capabilities=3D{Initiator}
Jun 20 13:35:01 dnccor50 kernel: Fusion MPT SCSI Host driver 3.01.18
Jun 20 13:35:01 dnccor50 kernel: scsi2 : ioc0: LSI53C1030, =
FwRev=3D01032316h, Ports=3D1, MaxQ=3D222, IRQ=3D193
Jun 20 13:35:01 dnccor50 kernel: scsi3 : ioc1: LSI53C1030, =
FwRev=3D01032316h, Ports=3D1, MaxQ=3D222, IRQ=3D201
Jun 20 13:35:01 dnccor50 kernel: ACPI: PCI interrupt 0000:06:08.0[A] -> =
GSI 64 (level, low) -> IRQ 209
Jun 20 13:35:01 dnccor50 kernel: ips 0000:06:08.0: Warning ! ! ! =
ServeRAID Version Mismatch
Jun 20 13:35:01 dnccor50 kernel: ips 0000:06:08.0: Bios =3D 7.00.14, =
Firmware =3D 7.00.14, Device Driver =3D 7.10.18=20
Jun 20 13:35:01 dnccor50 kernel: ips 0000:06:08.0: These levels should =
match to avoid possible compatibility problems.
Jun 20 13:35:01 dnccor50 kernel: scsi4 : IBM PCI ServeRAID 7.10.18  =
Build 731 <ServeRAID 6M>
Jun 20 13:35:01 dnccor50 kernel:   Vendor: IBM       Model: SERVERAID   =
      Rev: 1.00
Jun 20 13:35:01 dnccor50 kernel:   Type:   Direct-Access                =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel: SCSI device sdc: 143372288 512-byte =
hdwr sectors (73407 MB)
Jun 20 13:35:01 dnccor50 kernel: SCSI device sdc: drive cache: write =
through
Jun 20 13:35:01 dnccor50 kernel: SCSI device sdc: 143372288 512-byte =
hdwr sectors (73407 MB)
Jun 20 13:35:01 dnccor50 kernel: SCSI device sdc: drive cache: write =
through
Jun 20 13:35:01 dnccor50 kernel:  sdc: sdc1 sdc2 sdc3
Jun 20 13:35:01 dnccor50 kernel: Attached scsi disk sdc at scsi4, =
channel 0, id 0, lun 0
Jun 20 13:35:01 dnccor50 kernel:   Vendor: IBM       Model: SERVERAID   =
      Rev: 1.00
Jun 20 13:35:01 dnccor50 kernel:   Type:   Processor                    =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel:   Vendor: IBM       Model: 25P3495a =
S320  1  Rev: 1  =20
Jun 20 13:35:01 dnccor50 kernel:   Type:   Processor                    =
      ANSI SCSI revision: 02
Jun 20 13:35:01 dnccor50 kernel: EXT3-fs: INFO: recovery required on =
readonly filesystem.
Jun 20 13:35:01 dnccor50 kernel: EXT3-fs: write access will be enabled =
during recovery.
Jun 20 13:35:01 dnccor50 kernel: kjournald starting.  Commit interval 5 =
seconds
Jun 20 13:35:01 dnccor50 kernel: EXT3-fs: sdc2: orphan cleanup on =
readonly fs
Jun 20 13:35:01 dnccor50 kernel: EXT3-fs: sdc2: 14 orphan inodes =
deleted
Jun 20 13:35:01 dnccor50 kernel: EXT3-fs: recovery complete.
Jun 20 13:35:01 dnccor50 kernel: EXT3-fs: mounted filesystem with =
ordered data mode.
Jun 20 13:35:01 dnccor50 kernel: SELinux:  Disabled at runtime.
Jun 20 13:35:01 dnccor50 kernel: SELinux:  Unregistering netfilter =
hooks
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg0 at scsi0, =
channel 0, id 0, lun 0,  type 12
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg1 at scsi0, =
channel 0, id 0, lun 2,  type 0
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg2 at scsi0, =
channel 0, id 1, lun 0,  type 12
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg3 at scsi0, =
channel 0, id 1, lun 2,  type 0
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg4 at scsi4, =
channel 0, id 0, lun 0,  type 0
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg5 at scsi4, =
channel 0, id 15, lun 0,  type 3
Jun 20 13:35:01 dnccor50 kernel: Attached scsi generic sg6 at scsi4, =
channel 1, id 8, lun 0,  type 3
Jun 20 13:35:01 dnccor50 kernel: Floppy drive(s): fd0 is 1.44M
Jun 20 13:35:01 dnccor50 kernel: FDC 0 is a National Semiconductor =
PC87306
Jun 20 13:35:01 dnccor50 kernel: tg3.c:v3.14 (November 15, 2004)
Jun 20 13:35:01 dnccor50 kernel: ACPI: PCI interrupt 0000:01:04.0[A] -> =
GSI 42 (level, low) -> IRQ 217
Jun 20 13:35:02 dnccor50 kernel: eth0: Tigon3 [partno(BCM95704A6) rev =
2002 PHY(5704)] (PCIX:100MHz:64-bit) 10/100/1000BaseT Ethernet =
00:09:6b:e6:42:1d
Jun 20 13:35:02 dnccor50 kernel: eth0: RXcsums[1] LinkChgREG[0] =
MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[1]=20
Jun 20 13:35:02 dnccor50 kernel: ACPI: PCI interrupt 0000:01:04.1[B] -> =
GSI 11 (level, low) -> IRQ 11
Jun 20 13:35:02 dnccor50 kernel: eth1: Tigon3 [partno(BCM95704A6) rev =
2002 PHY(5704)] (PCIX:100MHz:64-bit) 10/100/1000BaseT Ethernet =
00:09:6b:16:42:1d
Jun 20 13:35:02 dnccor50 kernel: eth1: RXcsums[1] LinkChgREG[0] =
MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[1]=20
Jun 20 13:35:02 dnccor50 kernel: parport_pc: VIA parallel port disabled =
in BIOS
Jun 20 13:35:02 dnccor50 kernel: USB Universal Host Controller =
Interface driver v2.2
Jun 20 13:35:02 dnccor50 kernel: ACPI: PCI interrupt 0000:00:05.2[D] -> =
GSI 18 (level, low) -> IRQ 225
Jun 20 13:35:02 dnccor50 kernel: uhci_hcd 0000:00:05.2: UHCI Host =
Controller
Jun 20 13:35:02 dnccor50 kernel: ip_tables: (C) 2000-2002 Netfilter =
core team
Jun 20 13:35:02 dnccor50 kernel: uhci_hcd 0000:00:05.2: irq 225, io =
base 0x1900
Jun 20 13:35:02 dnccor50 kernel: uhci_hcd 0000:00:05.2: new USB bus =
registered, assigned bus number 1
Jun 20 13:35:02 dnccor50 kernel: hub 1-0:1.0: USB hub found
Jun 20 13:35:02 dnccor50 kernel: hub 1-0:1.0: 2 ports detected
Jun 20 13:35:02 dnccor50 kernel: ACPI: PCI interrupt 0000:00:05.3[D] -> =
GSI 18 (level, low) -> IRQ 225
Jun 20 13:35:02 dnccor50 kernel: uhci_hcd 0000:00:05.3: UHCI Host =
Controller
Jun 20 13:35:02 dnccor50 kernel: uhci_hcd 0000:00:05.3: irq 225, io =
base 0x1920
Jun 20 13:35:02 dnccor50 kernel: uhci_hcd 0000:00:05.3: new USB bus =
registered, assigned bus number 2
Jun 20 13:35:02 dnccor50 kernel: hub 2-0:1.0: USB hub found
Jun 20 13:35:02 dnccor50 kernel: hub 2-0:1.0: 2 ports detected
Jun 20 13:35:02 dnccor50 kernel: md: Autodetecting RAID arrays.
Jun 20 13:35:02 dnccor50 kernel: md: autorun ...
Jun 20 13:35:02 dnccor50 kernel: md: ... autorun DONE.
Jun 20 13:35:02 dnccor50 kernel: tg3: eth0: Link is up at 100 Mbps, =
full duplex.
Jun 20 13:35:02 dnccor50 kernel: tg3: eth0: Flow control is off for TX =
and off for RX.
Jun 20 13:35:02 dnccor50 kernel: tg3: eth1: Link is up at 100 Mbps, =
half duplex.
Jun 20 13:35:02 dnccor50 kernel: tg3: eth1: Flow control is off for TX =
and off for RX.
Jun 20 13:35:02 dnccor50 kernel: ACPI: Power Button (FF) [PWRF]
Jun 20 13:35:02 dnccor50 kernel: ibm_acpi: ec object not found
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772032
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971504
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971505
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971506
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971507
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971508
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971509
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971510
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971511
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971512
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971513
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971514
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971515
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971516
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971517
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971518
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971519
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772032
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971504
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 4
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 5
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 17
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:02 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:02 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:02 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 24
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 24
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 56
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 56
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 120
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 120
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:03 dnccor50 kernel: EXT3 FS on sdc2, internal journal
Jun 20 13:35:03 dnccor50 kernel: device-mapper: 4.3.0-ioctl =
(2004-09-30) initialised: dm-devel@redhat.com
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772032
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772032
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971504
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971505
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971506
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971507
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971508
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971509
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971510
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971511
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971512
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971513
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971514
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971515
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971516
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971517
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971518
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971519
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772032
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971504
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 4
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 5
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 17
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:03 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:03 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:03 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 24
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 24
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 56
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 56
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 120
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 120
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:04 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:04 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:04 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772032
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971504
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 128
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 16
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 64
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 24
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:05 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 24
Jun 20 13:35:05 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:05 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 56
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 56
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 120
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 120
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 8
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 16
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:06 dnccor50 kernel: kjournald starting.  Commit interval 5 =
seconds
Jun 20 13:35:06 dnccor50 kernel: EXT3 FS on sdc1, internal journal
Jun 20 13:35:06 dnccor50 kernel: EXT3-fs: mounted filesystem with =
ordered data mode.
Jun 20 13:35:06 dnccor50 kernel: kjournald starting.  Commit interval 5 =
seconds
Jun 20 13:35:06 dnccor50 kernel: EXT3 FS on sda1, internal journal
Jun 20 13:35:06 dnccor50 kernel: EXT3-fs: mounted filesystem with =
ordered data mode.
Jun 20 13:35:06 dnccor50 kernel: Adding 19133404k swap on /dev/sdc3.  =
Priority:-1 extents:1
Jun 20 13:35:06 dnccor50 kernel: ip_tables: (C) 2000-2002 Netfilter =
core team
Jun 20 13:35:06 dnccor50 last message repeated 2 times
Jun 20 13:35:06 dnccor50 kernel: NET: Registered protocol family 10
Jun 20 13:35:06 dnccor50 kernel: Disabled Privacy Extensions on device =
c032a200(lo)
Jun 20 13:35:06 dnccor50 kernel: IPv6 over IPv4 tunneling driver
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 4
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 5
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 6
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 9
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 10
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 11
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 12
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 13
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 14
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 512
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 64
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 65
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 66
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 67
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 68
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 69
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 70
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 71
Jun 20 13:35:06 dnccor50 kernel: Device sdb not ready.
Jun 20 13:35:06 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 512
Jun 20 13:35:06 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 64
Jun 20 13:36:18 dnccor50 sshd(pam_unix)[4828]: session opened for user =
root by root(uid=3D0)
Jun 20 18:39:15 dnccor50 su(pam_unix)[4864]: session opened for user =
oracle by root(uid=3D0)
Jun 20 18:39:36 dnccor50 sshd(pam_unix)[4893]: session opened for user =
root by root(uid=3D0)
Jun 20 18:40:00 dnccor50 crond(pam_unix)[4932]: session opened for user =
root by (uid=3D0)
Jun 20 18:40:00 dnccor50 crond(pam_unix)[4932]: session closed for user =
root
Jun 20 18:50:01 dnccor50 crond(pam_unix)[5692]: session opened for user =
root by (uid=3D0)
Jun 20 18:50:01 dnccor50 crond(pam_unix)[5692]: session closed for user =
root
Jun 20 19:00:01 dnccor50 crond(pam_unix)[6039]: session opened for user =
root by (uid=3D0)
Jun 20 19:00:01 dnccor50 crond(pam_unix)[6039]: session closed for user =
root
Jun 20 19:01:01 dnccor50 crond(pam_unix)[6056]: session opened for user =
root by (uid=3D0)
Jun 20 19:01:01 dnccor50 crond(pam_unix)[6056]: session closed for user =
root
Jun 20 19:10:01 dnccor50 crond(pam_unix)[6278]: session opened for user =
root by (uid=3D0)
Jun 20 19:10:02 dnccor50 crond(pam_unix)[6278]: session closed for user =
root
Jun 20 19:20:01 dnccor50 crond(pam_unix)[6453]: session opened for user =
root by (uid=3D0)
Jun 20 19:20:01 dnccor50 crond(pam_unix)[6453]: session closed for user =
root
Jun 20 19:30:01 dnccor50 crond(pam_unix)[6560]: session opened for user =
root by (uid=3D0)
Jun 20 19:30:01 dnccor50 crond(pam_unix)[6560]: session closed for user =
root
Jun 20 19:40:01 dnccor50 crond(pam_unix)[6613]: session opened for user =
root by (uid=3D0)
Jun 20 19:40:01 dnccor50 crond(pam_unix)[6613]: session closed for user =
root
Jun 20 19:48:22 dnccor50 sshd(pam_unix)[6721]: session opened for user =
root by root(uid=3D0)
Jun 20 19:50:01 dnccor50 crond(pam_unix)[6757]: session opened for user =
root by (uid=3D0)
Jun 20 19:50:01 dnccor50 crond(pam_unix)[6757]: session closed for user =
root
Jun 20 19:52:54 dnccor50 sshd(pam_unix)[6791]: session opened for user =
root by root(uid=3D0)
Jun 20 19:53:29 dnccor50 gconfd (root-6830): starting (version 2.8.1), =
pid 6830 user 'root'
Jun 20 19:53:29 dnccor50 gconfd (root-6830): Resolved address =
"xml:readonly:/etc/gconf/gconf.xml.mandatory" to a read-only =
configuration source at position 0
Jun 20 19:53:29 dnccor50 gconfd (root-6830): Resolved address =
"xml:readwrite:/root/.gconf" to a writable configuration source at =
position 1
Jun 20 19:53:29 dnccor50 gconfd (root-6830): Resolved address =
"xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only =
configuration source at position 2
Jun 20 19:53:29 dnccor50 kernel: program python is using a deprecated =
SCSI ioctl, please convert it to SG_IO
Jun 20 19:53:29 dnccor50 kernel: program python is using a deprecated =
SCSI ioctl, please convert it to SG_IO
Jun 20 19:53:29 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:29 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:29 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:29 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:29 dnccor50 kernel: program python is using a deprecated =
SCSI ioctl, please convert it to SG_IO
Jun 20 19:53:29 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:29 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 4
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 5
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 6
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 9
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 10
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 11
Jun 20 19:53:29 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 12
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 13
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 14
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772152
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971519
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772152
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971519
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:53:30 dnccor50 kernel: Device sdb not ready.
Jun 20 19:53:30 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:53:30 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:40 dnccor50 kernel: program python is using a deprecated =
SCSI ioctl, please convert it to SG_IO
Jun 20 19:55:40 dnccor50 kernel: program python is using a deprecated =
SCSI ioctl, please convert it to SG_IO
Jun 20 19:55:40 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:40 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:40 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:40 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:40 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:40 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:40 dnccor50 kernel: program python is using a deprecated =
SCSI ioctl, please convert it to SG_IO
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 1
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 2
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 3
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 4
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 5
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 6
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 7
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 8
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 9
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 10
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 11
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 12
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 13
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 14
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 15
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772152
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971519
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 167772152
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 20971519
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0
Jun 20 19:55:41 dnccor50 kernel: Device sdb not ready.
Jun 20 19:55:41 dnccor50 kernel: end_request: I/O error, dev sdb, =
sector 0
Jun 20 19:55:41 dnccor50 kernel: Buffer I/O error on device sdb, =
logical block 0

------_=_NextPart_000_01C57668.18116259
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_000_01C57668.18116259--
