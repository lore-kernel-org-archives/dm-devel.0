From: Mikael Andersson <mikael@karett.se>
Subject: Disk io deadlocks during large-file io
Date: Thu, 21 Apr 2005 20:37:59 +0200
Message-ID: <4267F307.8080009@karett.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
Cc: axboe@suse.de
List-Id: dm-devel.ids

Disk io deadlocks during large-file io.

During heavy disk io involving creating large files, some parts
of the kernel locks up. In most cases all disk output becomes
impossible, but sometimes you can write small things to disk, like
echo > test.txt might work sometimes. On reiserfs the lockups tend to be
more severe. The problem only occurs when i have both disks in my device
mapper mirror installed. if i remove one of the SATA cables, everything
works perfectly , except that devicemapper complains that the mirror is
degraded.

dm_unplug_all and dm_table_unplug appears to be present in the call
stack for at least one process for all complete dmesg's i have manged to
collect.

Tested versions from 2.6.11.7 up to 2.6.12-rc3 all show the same behaviour.

Kernel version:
Linux version 2.6.12-rc3 (root@bar) (gcc version 3.4.3-20050110 (Gentoo
Linux 3.4.3.20050110-r2, ssp-3.4.3.20050110-0, pie-8.7.7)) #1 Thu Apr 21
14:25:14 CEST 2005

Output from <alt><syrq>-T when the deadlock has occured is provided at
the end of this mail.


How to reproduce:
rsync over 100Mbit ethernet like this works for me:

rsync -rav rsync://site/dir-with-1G-files . &
and then compile eg. glibc or anything that takes
20 minutes or more.

Software:
Linux bar 2.6.12-rc3 #1 Thu Apr 21 14:25:14 CEST 2005 x86_64 AMD
Athlon(tm) 64 Processor 3800+ AuthenticAMD GNU/Linux

Gnu C                  3.4.3-20050110
Gnu make               3.80
binutils               2.15.92.0.2
util-linux             2.12q
mount                  2.12q
module-init-tools      3.1
e2fsprogs              1.37
reiserfsprogs          3.6.19
reiser4progs           line
Linux C Library        2.3.4
Dynamic linker (ldd)   2.3.4
Procps                 3.2.5
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
udev                   045
Modules Loaded

Processor information:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 15
model name	: AMD Athlon(tm) 64 Processor 3800+
stepping	: 0
cpu MHz		: 2412.410
cache size	: 512 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 pni syscall nx mmxext lm 3dnowext
3dnow k8c+
bogomips	: 4784.12
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

Module information:
None

Loaded driver and hardware information

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial
0960-0967 : 0000:00:08.0
  0960-0967 : sata_nv
0970-0977 : 0000:00:07.0
  0970-0977 : sata_nv
09e0-09e7 : 0000:00:08.0
  09e0-09e7 : sata_nv
09f0-09f7 : 0000:00:07.0
  09f0-09f7 : sata_nv
0b60-0b63 : 0000:00:08.0
  0b60-0b63 : sata_nv
0b70-0b73 : 0000:00:07.0
  0b70-0b73 : sata_nv
0be0-0be3 : 0000:00:08.0
  0be0-0be3 : sata_nv
0bf0-0bf3 : 0000:00:07.0
  0bf0-0bf3 : sata_nv
0cf8-0cff : PCI conf1
4000-407f : motherboard
  4000-4003 : PM1a_EVT_BLK
  4004-4005 : PM1a_CNT_BLK
  4008-400b : PM_TMR
  401c-401c : PM2_CNT_BLK
  4020-4027 : GPE0_BLK
4080-40ff : motherboard
  4080-40ff : pnp 00:00
4400-447f : motherboard
  4400-447f : pnp 00:00
4480-44ff : motherboard
  44a0-44af : GPE1_BLK
4800-487f : motherboard
  4800-487f : pnp 00:00
4880-48ff : motherboard
  4880-48ff : pnp 00:00
4c00-4c3f : 0000:00:01.1
4c40-4c7f : 0000:00:01.1
a000-a0ff : 0000:05:07.0
  a000-a0ff : 8139too
b000-b007 : 0000:00:0a.0
  b000-b007 : forcedeth
c400-c40f : 0000:00:08.0
  c400-c40f : sata_nv
d800-d80f : 0000:00:07.0
  d800-d80f : sata_nv
dc00-dcff : 0000:00:04.0
e000-e0ff : 0000:00:04.0
e400-e41f : 0000:00:01.1
f000-f00f : 0000:00:06.0
  f000-f007 : ide0
  f008-f00f : ide1

00000000-0009cfff : System RAM
0009d000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000d4000-000dabff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3ffeffff : System RAM
  00100000-004a63b4 : Kernel code
  004a63b5-006712a7 : Kernel data
3fff0000-3fff2fff : ACPI Non-volatile Storage
3fff3000-3fffffff : ACPI Tables
c0000000-cfffffff : PCI Bus #01
  c0000000-c7ffffff : 0000:01:00.0
  c8000000-cbffffff : 0000:01:00.0
  cc000000-ccffffff : 0000:01:00.0
d0000000-d0003fff : 0000:05:06.0
d0004000-d00047ff : 0000:05:06.0
  d0004000-d00047ff : ohci1394
d0005000-d00050ff : 0000:05:07.0
  d0005000-d00050ff : 8139too
d0100000-d0100fff : 0000:00:0a.0
  d0100000-d0100fff : forcedeth
d0101000-d0101fff : 0000:00:08.0
  d0101000-d0101fff : sata_nv
d0102000-d0102fff : 0000:00:07.0
  d0102000-d0102fff : sata_nv
d0103000-d0103fff : 0000:00:04.0
d0104000-d0104fff : 0000:00:02.0
  d0104000-d0104fff : ohci_hcd
d0105000-d01050ff : 0000:00:02.1
  d0105000-d01050ff : ehci_hcd
e0000000-efffffff : reserved
fec00000-fec00fff : reserved
fee00000-feefffff : reserved
fefffc00-feffffff : reserved
ffff0000-ffffffff : reserved

PCI information

0000:00:00.0 Memory controller: nVidia Corporation CK804 Memory
Controller (rev a3)
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [44] #08 [01e0]
	Capabilities: [e0] #08 [a801]

0000:00:01.0 ISA bridge: nVidia Corporation: Unknown device 0050 (rev a3)
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0

0000:00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at e400
	Region 4: I/O ports at 4c00 [size=64]
	Region 5: I/O ports at 4c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:02.0 USB Controller: nVidia Corporation CK804 USB Controller
(rev a2) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at d0104000 (32-bit, non-prefetchable)
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:02.1 USB Controller: nVidia Corporation CK804 USB Controller
(rev a3) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 3
	Region 0: Memory at d0105000 (32-bit, non-prefetchable)
	Capabilities: [44] #0a [2098]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97
Audio Controller (rev a2)
	Subsystem: ASUSTeK Computer Inc.: Unknown device 812a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at dc00
	Region 1: I/O ports at e000 [size=256]
	Region 2: Memory at d0103000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev a2)
(prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA
Controller (rev a3) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 09f0
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at d800 [size=16]
	Region 5: Memory at d0102000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA
Controller (rev a3) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc.: Unknown device 815a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at 09e0
	Region 1: I/O ports at 0be0 [size=4]
	Region 2: I/O ports at 0960 [size=8]
	Region 3: I/O ports at 0b60 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Region 5: Memory at d0101000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=128
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: d0000000-d00fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

0000:00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
	Subsystem: ASUSTeK Computer Inc.: Unknown device 8141
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at d0100000 (32-bit, non-prefetchable)
	Region 1: I/O ports at b000 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-

0000:00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, cache line size 08
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable+
		Address: 00000000fee01004  Data: 4041
	Capabilities: [58] #08 [a800]
	Capabilities: [80] #10 [0141]

0000:00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, cache line size 08
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable+
		Address: 00000000fee01004  Data: 4049
	Capabilities: [58] #08 [a800]
	Capabilities: [80] #10 [0141]

0000:00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, cache line size 08
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable+
		Address: 00000000fee01004  Data: 4051
	Capabilities: [58] #08 [a800]
	Capabilities: [80] #10 [0141]

0000:00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, cache line size 08
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: c0000000-cfffffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable+
		Address: 00000000fee01004  Data: 4059
	Capabilities: [58] #08 [a800]
	Capabilities: [80] #10 [0141]

0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Capabilities: [80] #08 [2101]

0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

0000:01:00.0 VGA compatible controller: nVidia Corporation NV43 [MSI
NX6600GT-TD128E] (rev a2) (prog-if 00 [VGA])
	Subsystem: XFX Pine Group Inc.: Unknown device 2118
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0, cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at c8000000 (32-bit, non-prefetchable)
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=128M]
	Region 3: Memory at cc000000 (64-bit, non-prefetchable) [size=16M]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] #10 [0001]

0000:05:06.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b
Link Layer Controller (rev 01) (prog-if 10 [OHCI])
	Subsystem: Texas Instruments TSB82AA2 IEEE-1394b Link Layer Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (750ns min, 1000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d0004000 (32-bit, non-prefetchable)
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

0000:05:07.0 Ethernet controller: Accton Technology Corporation
SMC2-1211TX (rev 10)
	Subsystem: Accton Technology Corporation EN-1207D Fast Ethernet Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 3
	Region 0: I/O ports at a000
	Region 1: Memory at d0005000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

SCSI information:
/proc/scsi/scsi doesn't exist

Other information:

output of SysRq : Show State with
linenumbers resolved by using:
addr2line -f -e vmlinux <addr>. Original
dmesg output at end of mail.


SysRq
Process: init
init S 000000010024049a 0 1 0 2 (NOTLB)
ffff810002161d48 0000000000000086 ffff810002161d38
ffff81003febcc80 000000d002161d40 ffff81003f393048
0000000000000256 ffff81000213c760 ffffffff805a74c0
ffff81000213c970
<ffffffff804a32f8> schedule_timeout kernel/timer.c:1122
<ffffffff801405c0> process_timeout kernel/timer.c:1049
<ffffffff8019d7d2> pipe_poll fs/pipe.c:410
<ffffffff801a5e02> do_select fs/select.c:259
<ffffffff801a56f0> __pollwait fs/select.c:91
<ffffffff801a613f> sys_select fs/select.c:358
<ffffffff8010dfe6> system_call ??:0
Process: ksoftirqd/0
ksoftirqd/0 S 0000000000000000 0 2 1 3 (L-TLB)
ffff810002165f08 0000000000000046 0000000000000007
ffffffff8014e710 00000073fffffffc ffffffff805a74c0
0000000000000000 ffff81000213c030 ffffffff805a74c0
ffff81000213c240
<ffffffff8014e710> __rcu_process_callbacks kernel/rcupdate.c:146
<ffffffff8013b264> tasklet_action kernel/softirq.c:269
<ffffffff8013b380> ksoftirqd kernel/softirq.c:351
<ffffffff8013b3c5> ksoftirqd include/asm/current.h:11
<ffffffff8013b380> ksoftirqd kernel/softirq.c:351
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: khelper
khelper S ffff81003ffe2600 0 4 1 5 3 (L-TLB)
ffff81003fc2fe48 0000000000000046 ffff81003caa9bb0
0000000000000000 0000000300000000 ffff81003ffe2690
0000007800000000 ffff81003fc03070 ffff81003f9ec0b0
ffff81003fc03280
<ffffffff8014c3b0> __call_usermodehelper kernel/kmod.c:192
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kthread
kthread S ffff81003fc13e00 0 5 1 7 142 4 (L-TLB)
ffff81003fc41e48 0000000000000046 ffff81003fe19b00
0000000000000000 0000000300000000 ffff81003fc13e90
0000007300000000 ffff81003fc147e0 ffff8100023537a0
ffff81003fc149f0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kacpid
kacpid S ffff81000220e800 0 7 5 139 (L-TLB)
ffff810002235e48 0000000000000046 ffff81003fc2fd40
0000000000000002 ffff810002166040 0000000000000000
000000780213c760 ffff81003fc140b0 ffff810002238820
ffff81003fc142c0
<ffffffff80147c5f> do_sigaction kernel/signal.c:2417
<ffffffff8012d5a5> try_to_wake_up kernel/sched.c:304
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80279120> dummy_d_instantiate security/dummy.c:826
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kblockd/0
kblockd/0 S ffff810002247600 0 139 5 210 7 (L-TLB)
ffff8100022b7e48 0000000000000046 0000000000000000
ffff810022018ba0 0000000300000000 ffff810002247690
0000007400000000 ffff810002238820 ffff81003f99a130
ffff810002238a30
<ffffffff802f23c0> as_work_handler drivers/block/as-iosched.c:1780
<ffffffff802f23c0> as_work_handler drivers/block/as-iosched.c:1780
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80279120> dummy_d_instantiate security/dummy.c:826
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: khubd
khubd S 0000000e84de7b78 0 142 1 212 5 (L-TLB)
ffff810002309e28 0000000000000046 ffff81003f8e5800
000000000000000a ffff81003f8e9680 ffff81003f8e8c00
0000007502309eb4 ffff8100022380f0 ffff81003fc03070
ffff810002238300
<ffffffff803bf123> hub_thread drivers/usb/core/hub.c:2810
<ffffffff801d2335> proc_pid_flush fs/proc/base.c:1751
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff8014c3b0> __call_usermodehelper kernel/kmod.c:192
<ffffffff8010eafb> child_rip ??:0
<ffffffff80290f00> vgacon_cursor drivers/video/console/vgacon.c:442
<ffffffff803be280> hub_thread drivers/usb/core/hub.c:2798
<ffffffff8010eaf3> child_rip ??:0
Process: pdflush
pdflush S ffff81000232def0 0 210 5 211 139 (L-TLB)
ffff81000232deb8 0000000000000046 0000000100237a37
0000000000019993 0000000000000000 0000000000000000
ffff81000232de38 ffff8100022e2860 ffffffff805a74c0
ffff8100022e2a70
<ffffffff801689d6> pdflush mm/pdflush.c:113
<ffffffff80168800> pdflush mm/pdflush.c:171
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: pdflush
pdflush S ffff81000232fef0 0 211 5 213 210 (L-TLB)
ffff81000232feb8 0000000000000046 0000000000006664
0000000000019993 0000000000005b78 0000000000000000
000000730000216e ffff8100022e2130 ffff8100022e2860
ffff8100022e2340
<ffffffff801689d6> pdflush mm/pdflush.c:113
<ffffffff80168800> pdflush mm/pdflush.c:171
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: aio/0
aio/0 S 0000000c41d13ce5 0 213 5 865 211 (L-TLB)
ffff810002333e48 0000000000000046 0000356300000000
3433323100000000 0000000000000035 6962732f00000001
00000078696d2f6e ffff810002300030 ffff81003fc03070
ffff810002300240
<ffffffff80147c5f> do_sigaction kernel/signal.c:2417
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kswapd0
kswapd0 S ffffffff805b99c0 0 212 1 804 142 (L-TLB)
ffff810002331e28 0000000000000046 ffff810002331da8
ffff810002331da8 ffff8100010f0300 0000000000000292
00000074022dc7c0 ffff810002300760 ffff81003dfc3130
ffff810002300970
<ffffffff8016e221> shrink_slab mm/vmscan.c:226
<ffffffff8016ff24> kswapd mm/vmscan.c:1216
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff8010eafb> child_rip ??:0
<ffffffff8016fdf0> kswapd mm/vmscan.c:1169
<ffffffff8010eaf3> child_rip ??:0
Process: kseriod
kseriod S ffff81003f853ef8 0 804 1 869 212 (L-TLB)
ffff81003f853e98 0000000000000046 ffff81003f066ba8
ffffffff805f9910 00000000ffffffea ffffffff805d8d28
0000000000000001 ffff8100023537a0 ffffffff805a74c0
ffff8100023539b0
<ffffffff802d5915> serio_thread drivers/input/serio/serio.c:346
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff8010eafb> child_rip ??:0
<ffffffff80290f00> vgacon_cursor drivers/video/console/vgacon.c:442
<ffffffff802d52b0> serio_thread drivers/input/serio/serio.c:339
<ffffffff8010eaf3> child_rip ??:0
Process: ata/0
ata/0 S ffff81003f863000 0 865 5 920 213 (L-TLB)
ffff81003f89be48 0000000000000046 0000000000000296
00000000000003e7 0000000300000000 ffff81003f863090
0000007300000000 ffff810002353070 ffff81000213c760
ffff810002353280
<ffffffff8012d3d5> deactivate_task kernel/sched.c:743
<ffffffff80378950> ata_pio_task drivers/scsi/libata-core.c:2489
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: scsi_eh_0
scsi_eh_0 S ffff81003f89dec8 0 869 1 870 804 (L-TLB)
ffff81003f89dd78 0000000000000046 0000000000000246
ffffffff8013076f ffffffff8014df4f ffff81003feb8db0
000000743fc19480 ffff81003f8687e0 ffff81000213c760
ffff81003f8689f0
<ffffffff8013076f> mm_release kernel/fork.c:425
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff804a1206> __down_interruptible arch/x86_64/kernel/semaphore.c:139
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff804a3b2e> __down_failed_interruptible ??:0
<ffffffff80349d94> .text.lock.scsi_error ??:0
<ffffffff801d2335> proc_pid_flush fs/proc/base.c:1751
<ffffffff8014c3b0> __call_usermodehelper kernel/kmod.c:192
<ffffffff8010eafb> child_rip ??:0
<ffffffff803490c0> scsi_error_handler drivers/scsi/scsi_error.c:1628
<ffffffff8010eaf3> child_rip ??:0
Process: scsi_eh_1
scsi_eh_1 S ffff81003f89fec8 0 870 1 873 869 (L-TLB)
ffff81003f89fd78 0000000000000046 0000000000000246
ffffffff8013076f ffffffff8014df4f ffff81003feb8db0
000000753fc19480 ffff81003f8680b0 ffff81000213c760
ffff81003f8682c0
<ffffffff8013076f> mm_release kernel/fork.c:425
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff804a1206> __down_interruptible arch/x86_64/kernel/semaphore.c:139
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff804a3b2e> __down_failed_interruptible ??:0
<ffffffff80349d94> .text.lock.scsi_error ??:0
<ffffffff8010eafb> child_rip ??:0
<ffffffff803490c0> scsi_error_handler drivers/scsi/scsi_error.c:1628
<ffffffff8010eaf3> child_rip ??:0
Process: scsi_eh_2
scsi_eh_2 S ffff81003f8b3ec8 0 873 1 874 870 (L-TLB)
ffff81003f8b3d78 0000000000000046 0000000000000246
ffffffff8013076f ffffffff8014df4f ffff81003feb8db0
000000753fc19480 ffff81003f872820 ffff81000213c760
ffff81003f872a30
<ffffffff8013076f> mm_release kernel/fork.c:425
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff804a1206> __down_interruptible arch/x86_64/kernel/semaphore.c:139
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff804a3b2e> __down_failed_interruptible ??:0
<ffffffff80349d94> .text.lock.scsi_error ??:0
<ffffffff8010eafb> child_rip ??:0
<ffffffff803490c0> scsi_error_handler drivers/scsi/scsi_error.c:1628
<ffffffff8010eaf3> child_rip ??:0
Process: scsi_eh_3
scsi_eh_3 S ffff81003f8b5ec8 0 874 1 892 873 (L-TLB)
ffff81003f8b5d78 0000000000000046 0000000000000246
ffffffff8013076f ffffffff8014df4f ffff81003feb8db0
000000753fc19480 ffff81003f8720f0 ffff81000213c760
ffff81003f872300
<ffffffff8013076f> mm_release kernel/fork.c:425
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff804a1206> __down_interruptible arch/x86_64/kernel/semaphore.c:139
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff804a3b2e> __down_failed_interruptible ??:0
<ffffffff80349d94> .text.lock.scsi_error ??:0
<ffffffff8010eafb> child_rip ??:0
<ffffffff803490c0> scsi_error_handler drivers/scsi/scsi_error.c:1628
<ffffffff8010eaf3> child_rip ??:0
Process: khpsbpkt
khpsbpkt S ffffffff805f0a60 0 892 1 896 874 (L-TLB)
ffff81003f8d9e68 0000000000000046 0000000000000246
ffffffff8013076f ffffffff8014df4f ffffffff805a74c0
000000733f87a860 ffff81003f87a860 ffff81003f87a130
ffff81003f87aa70
<ffffffff8013076f> mm_release kernel/fork.c:425
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff804a1206> __down_interruptible arch/x86_64/kernel/semaphore.c:139
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff804a3b2e> __down_failed_interruptible ??:0
<ffffffff80290f00> vgacon_cursor drivers/video/console/vgacon.c:442
<ffffffff803918f4> .text.lock.ieee1394_core
drivers/ieee1394/ieee1394_core.c:1067
<ffffffff8010eafb> child_rip ??:0
<ffffffff80290f00> vgacon_cursor drivers/video/console/vgacon.c:442
<ffffffff80391830> hpsbpkt_thread drivers/ieee1394/ieee1394_core.c:1034
<ffffffff8010eaf3> child_rip ??:0
Process: knodemgrd_0
knodemgrd_0 S ffff810002352410 0 896 1 1692 892 (L-TLB)
ffff81003f8fdd98 0000000000000046 ffff81003fead010
ffffc20000386000 ffff81003feae008 ffffc20000386000
ffffc20000386000 ffff81003f87a130 ffffffff805a74c0
ffff81003f87a340
<ffffffff804a1206> __down_interruptible arch/x86_64/kernel/semaphore.c:139
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff804a3b2e> __down_failed_interruptible ??:0
<ffffffff803980c1> .text.lock.nodemgr ??:0
<ffffffff8010eafb> child_rip ??:0
<ffffffff80396ea0> nodemgr_host_thread drivers/ieee1394/nodemgr.c:1494
<ffffffff8010eaf3> child_rip ??:0
Process: kcryptd/0
kcryptd/0 S ffff81003f8e8a00 0 920 5 921 865 (L-TLB)
ffff81003f92fe48 0000000000000046 ffff81003fc2fd40
0000000000000002 ffff810002166040 0000000000000000
0000006f0213c760 ffff81003f8d4760 ffff81003f8d4030
ffff81003f8d4970
<ffffffff80147c5f> do_sigaction kernel/signal.c:2417
<ffffffff8012d3d5> deactivate_task kernel/sched.c:743
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kmirrord/0
kmirrord/0 D 0000025b9d930a8c 0 921 5 1670 920 (L-TLB)
ffff81003f931ab8 0000000000000046 0000000000000200
ffffffff8016a106 ffff81000601b300 0000000000000001
000000733f931c30 ffff81003f8d4030 ffff81003d8ed130
ffff81003f8d4240
<ffffffff8016a106> cache_alloc_refill mm/slab.c:910
<ffffffff804a31cf> io_schedule include/asm/atomic.h:117
<ffffffff80164c43> mempool_alloc mm/mempool.c:242
<ffffffff80413250> bvec_get_page drivers/md/dm-io.c:200
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff8041cffc> __rh_alloc drivers/md/dm-raid1.c:237
<ffffffff80413250> bvec_get_page drivers/md/dm-io.c:200
<ffffffff8041d483> rh_inc_pending drivers/md/dm-raid1.c:274
<ffffffff8041e3c8> do_work drivers/md/dm-raid1.c:819
<ffffffff8041cf60> region_free drivers/md/dm-raid1.c:132
<ffffffff804a18e4> schedule kernel/sched.c:1376
<ffffffff8041d810> do_work drivers/md/dm-raid1.c:861
<ffffffff8014cc5b> worker_thread kernel/workqueue.c:174
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kcopyd
kcopyd S ffff81003e8b0e00 0 1670 5 921 (L-TLB)
ffff81003e8d9e48 0000000000000046 ffffffff805fb450
ffffffff80413c00 0000000300000000 ffff81003e8aee90
0000007700000000 ffff8100021c67e0 ffff81003f9257a0
ffff8100021c69f0
<ffffffff80413c00> run_complete_job drivers/md/kcopyd.c:290
<ffffffff80147c5f> do_sigaction kernel/signal.c:2417
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8014caba> worker_thread kernel/workqueue.c:208
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8014c990> worker_thread kernel/workqueue.c:183
<ffffffff8015361d> kthread kernel/kthread.c:95
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff8010eafb> child_rip ??:0
<ffffffff80153660> keventd_create_kthread kernel/kthread.c:107
<ffffffff80153550> kthread kernel/kthread.c:68
<ffffffff8010eaf3> child_rip ??:0
Process: kjournald
kjournald D ffff81003e33bcd8 0 1692 1 1998 896 (L-TLB)
ffff81003e33bc28 0000000000000046 ffff81003f8607b0
ffffffff802e9f73 ffff81003f8607b0 ffffffff802ea05d
0000007d00000008 ffff81003f925070 ffff81002d06c0b0
ffff81003f925280
<ffffffff802e9f73> __generic_unplug_device drivers/block/ll_rw_blk.c:1456
<ffffffff802ea05d> generic_unplug_device drivers/block/ll_rw_blk.c:1482
<ffffffff8018d030> sync_buffer fs/buffer.c:57
<ffffffff804a31cf> io_schedule include/asm/atomic.h:117
<ffffffff8018d06b> sync_buffer fs/buffer.c:68
<ffffffff804a3410> __wait_on_bit kernel/wait.c:162
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff8018d030> sync_buffer fs/buffer.c:57
<ffffffff804a3513> out_of_line_wait_on_bit kernel/wait.c:176
<ffffffff80154220> wake_bit_function kernel/wait.c:139
<ffffffff80154220> wake_bit_function kernel/wait.c:139
<ffffffff8021f777> journal_commit_transaction include/asm/bitops.h:236
<ffffffff804a18e4> schedule kernel/sched.c:1376
<ffffffff8022395c> kjournald fs/jbd/journal.c:165
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff80223710> commit_timeout fs/jbd/revoke.c:694
<ffffffff8010eafb> child_rip ??:0
<ffffffff8041cf60> region_free drivers/md/dm-raid1.c:132
<ffffffff80223730> kjournald fs/jbd/journal.c:125
<ffffffff8010eaf3> child_rip ??:0
Process: udevd
udevd S ffff81003df6be00 0 1998 1 5945 1692 (NOTLB)
ffff81003d54fd48 0000000000000082 0000000000000003
0000000b0000000e 000000d000000296 ffffffff805a74c0
0000000000000256 ffff81003f09e7e0 ffffffff805a74c0
ffff81003f09e9f0
<ffffffff804a323e> schedule_timeout kernel/timer.c:1094
<ffffffff801668cf> __get_free_pages mm/page_alloc.c:918
<ffffffff801a5e02> do_select fs/select.c:259
<ffffffff8013ae7f> current_fs_time kernel/time.c:456
<ffffffff801a56f0> __pollwait fs/select.c:91
<ffffffff801a613f> sys_select fs/select.c:358
<ffffffff8010dfe6> system_call ??:0
Process: dhcpcd
dhcpcd S 000000010032bfad 0 6280 1 6381 5945 (NOTLB)
ffff810038ca3eb8 0000000000000082 0000000000000296
ffff81003df23ec8 ffff81003df0c2d0 ffffffff8011e8ec
000000783df2b080 ffff81003f1180b0 ffff81003dfc3860
ffff81003f1182c0
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff804a32f8> schedule_timeout kernel/timer.c:1122
<ffffffff801405c0> process_timeout kernel/timer.c:1049
<ffffffff801406b2> sys_nanosleep kernel/timer.c:1178
<ffffffff8010dfe6> system_call ??:0
Process: login
login S ffff81003f99a978 0 6381 1 6529 6385 6280 (NOTLB)
ffff81003d8a7e88 0000000000000082 0000000000000000
ffffffff801a05ef ffff81003edbcdb0 0000000000000296
ffff81003dfaae90 ffff81003f99a860 ffffffff805a74c0
ffff81003f99aa70
<ffffffff801a05ef> link_path_walk include/linux/mount.h:59
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: login
login S 000001870b7ed37d 0 6385 1 6552 6386 6381 (NOTLB)
ffff810037fa3e88 0000000000000086 0000000000000000
ffffffff801a05ef ffff81003edbcdb0 0000000000000296
000000743df0ce50 ffff81003dfc3860 ffff81003d8ed860
ffff81003dfc3a70
<ffffffff801a05ef> link_path_walk include/linux/mount.h:59
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: login
login S 00000187fe03b931 0 6386 1 6554 6387 6385 (NOTLB)
ffff81003d5b7e88 0000000000000082 0000000000000000
ffffffff801a05ef ffff81003edbcdb0 0000000000000296
000000743d85d490 ffff81003f148070 ffff81003d8ed860
ffff81003f148280
<ffffffff801a05ef> link_path_walk include/linux/mount.h:59
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: login
login S 000001890012b17a 0 6387 1 6556 6388 6386 (NOTLB)
ffff810039929e88 0000000000000086 0000000000000000
ffffffff801a05ef ffff81003edbcdb0 0000000000000296
000000743f0c9910 ffff81003de6f070 ffff81003d8ed860
ffff81003de6f280
<ffffffff801a05ef> link_path_walk include/linux/mount.h:59
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: agetty
agetty S ffff810037b55000 0 6388 1 6389 6387 (NOTLB)
ffff81003caa9d28 0000000000000086 0000000000000292
0000000000000286 ffff810037b55000 0000000000000286
0000000300000000 ffff81003d88a0f0 ffffffff805a74c0
ffff81003d88a300
<ffffffff804a323e> schedule_timeout kernel/timer.c:1094
<ffffffff802c18a5> read_chan drivers/char/n_tty.c:1319
<ffffffff802cd390> con_write drivers/char/vt.c:2345
<ffffffff802c254c> write_chan drivers/char/n_tty.c:1495
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff802b91e1> tty_read drivers/char/tty_io.c:1015
<ffffffff8018b4a2> vfs_read fs/read_write.c:238
<ffffffff8018b7b3> sys_read fs/read_write.c:321
<ffffffff8010dfe6> system_call ??:0
Process: agetty
agetty S ffff81003e2ff000 0 6389 1 6582 6388 (NOTLB)
ffff810037f85d28 0000000000000086 0000000000000292
0000000000000286 ffff81003e2ff000 0000000000000286
0000000300000000 ffff81003de6f7a0 ffffffff805a74c0
ffff81003de6f9b0
<ffffffff804a323e> schedule_timeout kernel/timer.c:1094
<ffffffff802c18a5> read_chan drivers/char/n_tty.c:1319
<ffffffff802cd390> con_write drivers/char/vt.c:2345
<ffffffff802c254c> write_chan drivers/char/n_tty.c:1495
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff802b91e1> tty_read drivers/char/tty_io.c:1015
<ffffffff8018b4a2> vfs_read fs/read_write.c:238
<ffffffff8018b7b3> sys_read fs/read_write.c:321
<ffffffff8010dfe6> system_call ??:0
Process: bash
bash S 00000249e8a77d57 0 6529 6381 6585 (NOTLB)
ffff81003b459e88 0000000000000086 0000000000000046
ffff81003094de18 ffff810014d93030 0000000000000001
0000007414d93030 ffff8100021c60b0 ffff810035f0e820
ffff8100021c62c0
<ffffffff8012e520> __wake_up_common kernel/sched.c:2897
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff801a4fdd> vfs_ioctl fs/ioctl.c:153
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80146356> sys_rt_sigprocmask kernel/signal.c:2062
<ffffffff8010dfe6> system_call ??:0
Process: bash
bash S 0000024ad98f8c46 0 6552 6385 6586 (NOTLB)
ffff81000913de88 0000000000000082 0000000000000046
ffff8100292bfe18 ffff810031152430 0000000000000001
0000007531152430 ffff81003f1187e0 ffff81003d88a820
ffff81003f1189f0
<ffffffff8012e520> __wake_up_common kernel/sched.c:2897
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff801383a2> do_wait kernel/exit.c:1321
<ffffffff8010dfe6> system_call ??:0
Process: bash
bash S ffff81003c259000 0 6554 6386 (NOTLB)
ffff810003e6fd28 0000000000000086 0000000000000292
0000000000000286 ffff81003c259000 0000000000000286
0000000300000000 ffff81003f9257a0 ffffffff805a74c0
ffff81003f9259b0
<ffffffff804a323e> schedule_timeout kernel/timer.c:1094
<ffffffff80141f75> __dequeue_signal kernel/signal.c:541
<ffffffff802c18a5> read_chan drivers/char/n_tty.c:1319
<ffffffff802c254c> write_chan drivers/char/n_tty.c:1495
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff802b91e1> tty_read drivers/char/tty_io.c:1015
<ffffffff8018b4a2> vfs_read fs/read_write.c:238
<ffffffff8018b7b3> sys_read fs/read_write.c:321
<ffffffff8010dfe6> system_call ??:0
Process: bash
bash S ffff810037956000 0 6556 6387 (NOTLB)
ffff810033719d28 0000000000000082 0000000000000292
ffffffff8016638a 0000000137956000 0000000000000286
0000007400000000 ffff81003f09e0b0 ffff81003de6f070
ffff81003f09e2c0
<ffffffff8016638a> buffered_rmqueue include/linux/highmem.h:61
<ffffffff804a323e> schedule_timeout kernel/timer.c:1094
<ffffffff802c18a5> read_chan drivers/char/n_tty.c:1319
<ffffffff802c254c> write_chan drivers/char/n_tty.c:1495
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff802b91e1> tty_read drivers/char/tty_io.c:1015
<ffffffff8018b4a2> vfs_read fs/read_write.c:238
<ffffffff8018b7b3> sys_read fs/read_write.c:321
<ffffffff8010dfe6> system_call ??:0
Process: kjournald
kjournald S 0000022b492f375d 0 6582 1 6389 (L-TLB)
ffff8100292b5e18 0000000000000046 0000000000000000
ffffffff8012e520 0000000300000000 ffff81003f91a540
0000007400000000 ffff810035f0e0f0 ffff81003d8ed860
ffff810035f0e300
<ffffffff8012e520> __wake_up_common kernel/sched.c:2897
<ffffffff80223c25> kjournald fs/jbd/journal.c:199
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff80223710> commit_timeout fs/jbd/revoke.c:694
<ffffffff8010eafb> child_rip ??:0
<ffffffff80377240> ata_exec_command drivers/scsi/libata-core.c:239
<ffffffff80223730> kjournald fs/jbd/journal.c:125
<ffffffff8010eaf3> child_rip ??:0
Process: rsync
rsync S 000000010024d3e8 0 6585 6529 6587 (NOTLB)
ffff81003094dd48 0000000000000082 0000000000000292
ffffffff80458d15 000000103094dd38 ffffffff805a74c0
000000d0114568e8 ffff810035f0e820 ffffffff805a74c0
ffff810035f0ea30
<ffffffff80458d15> tcp_sendmsg net/ipv4/tcp.c:987
<ffffffff804a32f8> schedule_timeout kernel/timer.c:1122
<ffffffff801405c0> process_timeout kernel/timer.c:1049
<ffffffff801a5e02> do_select fs/select.c:259
<ffffffff801a56f0> __pollwait fs/select.c:91
<ffffffff801a613f> sys_select fs/select.c:358
<ffffffff8010dfe6> system_call ??:0
Process: emerge
emerge S 00000252b506d50c 0 6586 6552 6842 (NOTLB)
ffff8100292bfe88 0000000000000086 0000000000000000
000000000000000d ffffffff805b9910 0000000000000296
000000743f0c9350 ffff81003d88a820 ffff8100044c5760
ffff81003d88aa30
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: rsync
rsync D 000002643ede4096 0 6587 6585 (NOTLB)
ffff8100044ff6b8 0000000000000086 ffff81003f8607b0
ffffffff802e9f73 ffff81003f8607b0 ffffffff802ea05d
0000007302182800 ffff8100044c5760 ffff81003d8ed130
ffff8100044c5970
<ffffffff802e9f73> __generic_unplug_device drivers/block/ll_rw_blk.c:1456
<ffffffff802ea05d> generic_unplug_device drivers/block/ll_rw_blk.c:1482
<ffffffff8018d030> sync_buffer fs/buffer.c:57
<ffffffff804a31cf> io_schedule include/asm/atomic.h:117
<ffffffff8018d06b> sync_buffer fs/buffer.c:68
<ffffffff804a3581> __wait_on_bit_lock kernel/wait.c:188
<ffffffff8018d030> sync_buffer fs/buffer.c:57
<ffffffff804a3683> out_of_line_wait_on_bit_lock kernel/wait.c:204
<ffffffff80154220> wake_bit_function kernel/wait.c:139
<ffffffff80154220> wake_bit_function kernel/wait.c:139
<ffffffff80190760> __block_write_full_page include/linux/buffer_head.h:293
<ffffffff8020c510> ext3_get_block fs/ext3/inode.c:810
<ffffffff8020a879> ext3_ordered_writepage fs/ext3/inode.c:1329
<ffffffff801c0727> __mpage_writepages fs/mpage.c:717
<ffffffff8020a770> ext3_ordered_writepage fs/ext3/inode.c:1284
<ffffffff8020a770> ext3_ordered_writepage fs/ext3/inode.c:1284
<ffffffff801be1a6> __writeback_single_inode fs/fs-writeback.c:174
<ffffffff80191979> __getblk fs/buffer.c:1485
<ffffffff801bf027> sync_sb_inodes fs/fs-writeback.c:367
<ffffffff801bf703> writeback_inodes fs/fs-writeback.c:432
<ffffffff80167a99> balance_dirty_pages_ratelimited mm/page-writeback.c:225
<ffffffff80163158> generic_file_buffered_write mm/filemap.c:2024
<ffffffff8042d380> skb_copy_datagram_iovec net/core/datagram.c:221
<ffffffff801b03ee> inode_update_time include/linux/time.h:45
<ffffffff80163858> __generic_file_aio_write_nolock mm/filemap.c:2125
<ffffffff80429c93> sock_common_recvmsg net/core/sock.c:1297
<ffffffff80425db5> sock_aio_read net/socket.c:581
<ffffffff8016391f> generic_file_aio_write include/asm/semaphore.h:182
<ffffffff80208713> ext3_file_write fs/ext3/file.c:54
<ffffffff8018b5cd> do_sync_write fs/read_write.c:262
<ffffffff801a56f0> __pollwait fs/select.c:91
<ffffffff801541f0> autoremove_wake_function kernel/wait.c:124
<ffffffff801a626e> sys_select fs/select.c:279
<ffffffff8018b6e5> vfs_write fs/read_write.c:286
<ffffffff8018b843> sys_write fs/read_write.c:339
<ffffffff8010dfe6> system_call ??:0
Process: sandbox
sandbox S ffff8100044c5148 0 6842 6586 6843 (NOTLB)
ffff81002daa5e88 0000000000000086 0000000000000000
ffff81002f246070 ffffffff8014df4f 0000000000000296
0000007d3d85c350 ffff8100044c5030 ffff81002d06c0b0
ffff8100044c5240
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: ebuild.sh
ebuild.sh S ffff81002f246188 0 6843 6842 6883 (NOTLB)
ffff81002d7e1e88 0000000000000082 0000000000000000
ffff81002d06c7e0 ffffffff8014df4f 0000000000000296
0000007d021b0090 ffff81002f246070 ffff81002b64d820
ffff81002f246280
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: configure
configure S 0000025dc07f4166 0 6883 6843 14108 (NOTLB)
ffff81002d425e88 0000000000000086 0000000000000000
ffff81002d06c0b0 ffffffff8014df4f 0000000000000296
000000733dfaa310 ffff81002d06c7e0 ffff81003d8ed130
ffff81002d06c9f0
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: configure
configure S ffff81002d06c1c8 0 14108 6883 14109 (NOTLB)
ffff810005e8de88 0000000000000082 0000000000000000
ffff810027475860 ffffffff8014df4f 0000000000000296
000000733df0c890 ffff81002d06c0b0 ffff81002d06c7e0
ffff81002d06c2c0
<ffffffff8014df4f> attach_pid kernel/pid.c:153
<ffffffff8011e8ec> do_page_fault arch/x86_64/mm/fault.c:449
<ffffffff80139199> do_wait kernel/exit.c:1434
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff80148474> sys_rt_sigaction kernel/signal.c:2583
<ffffffff8012e4d0> default_wake_function kernel/sched.c:2871
<ffffffff8010dfe6> system_call ??:0
Process: x86_64-pc-lin
x86_64-pc-lin D 0000025dca0acf22 0 14109 14108 (NOTLB)
ffff81000fee7cf8 0000000000000082 ffff81003f8607b0
ffffffff802ea05d 0000000000000092 ffffffff805b9ec0
000000743f929500 ffff810027475860 ffff8100044c5760
ffff810027475a70
<ffffffff802ea05d> generic_unplug_device drivers/block/ll_rw_blk.c:1482
<ffffffff8040e3ad> dm_unplug_all drivers/md/dm.c:626
<ffffffff80160e60> sync_page mm/filemap.c:135
<ffffffff804a31cf> io_schedule include/asm/atomic.h:117
<ffffffff80160ea6> sync_page mm/filemap.c:150
<ffffffff804a3410> __wait_on_bit kernel/wait.c:162
<ffffffff80161178> wait_on_page_bit mm/filemap.c:424
<ffffffff80154220> wake_bit_function kernel/wait.c:139
<ffffffff80154220> wake_bit_function kernel/wait.c:139
<ffffffff8016d947> pagevec_lookup mm/swap.c:379
<ffffffff8016dc64> truncate_inode_pages mm/truncate.c:174
<ffffffff801b1c85> generic_delete_inode include/linux/security.h:1617
<ffffffff801a25eb> sys_unlink fs/namei.c:1883
<ffffffff8017a3c0> sys_brk mm/mmap.c:249
<ffffffff8010dfe6> system_call ??:0

[X.] Other notes, patches, fixes, workarounds:

Kernel compiled without smp,preempt. If i nice both running processes
the problem appears to be take a little longer to surface. I get 3-4Gb
transfered before a deadlock instead of 0.5-1.5 as i normally get.
