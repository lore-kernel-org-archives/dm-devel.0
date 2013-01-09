From: Peter & Kelly Passchier <peterkelly@passchier.net>
Subject: lvm2 hangs when creating snapshot of live root and IO to
 the root filesystem is happening
Date: Wed, 09 Jan 2013 12:20:03 -0800
Message-ID: <50EDD0F3.5030807@passchier.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
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
Cc: 1096520@bugs.launchpad.net
List-Id: dm-devel.ids

1. One-line summary
lvm2 hangs when creating snapshot of live root and IO to the root 
filesystem is happening


2. Full description
Root filesystem ext4 on lvm2 extent in luks-encrypted
partition with mainline kernel 3.8-rc2.
This is causing a hang:
lvcreate -s -n oscopy -v -l 100%FREE /dev/secret/root 2>/root/savefile

See: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1096520


3. Keywords
lvm2 mainline cryptsetup


4. cat /proc/version
Linux version 3.8.0-030800rc2-generic (root@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201301022235 SMP Thu Jan 3 03:46:06 
UTC 2013


5. Output of Oops
N/A


6. Script to replicate the problem
lvcreate -s -n oscopy -v -l 100%FREE /dev/secret/root 2>/root/savefile


7. lsb_release -rd
Description:	Ubuntu 10.04.4 LTS
Release:	10.04


7.1. sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux lucidv 3.8.0-030800rc2-generic #201301022235 SMP Thu Jan 3 
03:46:06 UTC 2013 i686 GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.11
PPP                    2.4.5
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
Modules Loaded         vboxvideo drm vboxsf vboxguest nls_utf8 isofs 
snd_intel8x0 snd_ac97_codec joydev e1000 ppdev hid_generic lp psmouse 
ac97_bus parport_pc i2c_piix4 usbhid parport serio_raw snd_pcm snd_timer 
hid mac_hid snd soundcore snd_page_alloc microcode ext2 dm_crypt


7.2. cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
stepping        : 7
cpu MHz         : 2484.382
cache size      : 6144 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 nx rdtscp constant_tsc pni 
monitor ssse3
bogomips        : 4968.76
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


7.3. cat /proc/modules
vboxvideo 12539 0 [permanent], Live 0xe093b000 (OF)
drm 229318 1 vboxvideo, Live 0xe1a82000
vboxsf 42327 1 [permanent], Live 0xe09b0000 (OF)
vboxguest 206361 2 vboxsf,[permanent], Live 0xe09e1000 (OF)
nls_utf8 12493 1 - Live 0xe080b000
isofs 39595 1 - Live 0xe0923000
snd_intel8x0 33458 0 - Live 0xe0931000
snd_ac97_codec 110254 1 snd_intel8x0, Live 0xe095b000
joydev 17329 0 - Live 0xe0898000
e1000 105764 0 - Live 0xe0908000
ppdev 12849 0 - Live 0xe0893000
hid_generic 12484 0 - Live 0xe0869000
lp 17455 0 - Live 0xe0885000
psmouse 77519 0 - Live 0xe0947000
ac97_bus 12670 1 snd_ac97_codec, Live 0xe0838000
parport_pc 32114 0 - Live 0xe085a000
i2c_piix4 13227 0 - Live 0xe088b000
usbhid 46125 0 - Live 0xe08fb000
parport 40930 3 ppdev,lp,parport_pc, Live 0xe089f000
serio_raw 13031 0 - Live 0xe082b000
snd_pcm 85934 2 snd_intel8x0,snd_ac97_codec, Live 0xe08d5000
snd_timer 28931 1 snd_pcm, Live 0xe08cc000
hid 82878 2 hid_generic,usbhid, Live 0xe08b0000
mac_hid 13077 0 - Live 0xe0864000
snd 62674 4 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer, Live 0xe0874000
soundcore 14635 1 snd, Live 0xe0855000
snd_page_alloc 18398 2 snd_intel8x0,snd_pcm, Live 0xe083d000
microcode 18433 0 - Live 0xe0832000
ext2 63952 1 - Live 0xe0844000
dm_crypt 22524 1 - Live 0xe0804000


7.4. cat /proc/ioports /proc/iomem
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc_cmos
   0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:01.1
   0170-0177 : ata_piix
01f0-01f7 : 0000:00:01.1
   01f0-01f7 : ata_piix
0376-0376 : 0000:00:01.1
   0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:01.1
   03f6-03f6 : ata_piix
0cf8-0cff : PCI conf1
4000-4003 : ACPI PM1a_EVT_BLK
4004-4005 : ACPI PM1a_CNT_BLK
4008-400b : ACPI PM_TMR
4020-4021 : ACPI GPE0_BLK
d000-d00f : 0000:00:01.1
   d000-d00f : ata_piix
d010-d017 : 0000:00:03.0
   d010-d017 : e1000
d020-d03f : 0000:00:04.0
d100-d1ff : 0000:00:05.0
   d100-d1ff : Intel 82801AA-ICH
d200-d23f : 0000:00:05.0
   d200-d23f : Intel 82801AA-ICH
d240-d247 : 0000:00:0d.0
   d240-d247 : ahci
d250-d257 : 0000:00:0d.0
   d250-d257 : ahci
d260-d26f : 0000:00:0d.0
   d260-d26f : ahci
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e2000-000e2fff : Adapter ROM
000f0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
   01000000-0162d66c : Kernel code
   0162d66d-01933a3f : Kernel data
   019ff000-01adafff : Kernel bss
1fff0000-1fffffff : ACPI Tables
e0000000-e1ffffff : 0000:00:02.0
f0000000-f001ffff : 0000:00:03.0
   f0000000-f001ffff : e1000
f0400000-f07fffff : 0000:00:04.0
   f0400000-f07fffff : vboxguest
f0800000-f0803fff : 0000:00:04.0
f0804000-f0804fff : 0000:00:06.0
   f0804000-f0804fff : ohci_hcd
f0805000-f0805fff : 0000:00:0b.0
   f0805000-f0805fff : ehci_hcd
f0806000-f0807fff : 0000:00:0d.0
   f0806000-f0807fff : ahci
fee00000-fee00fff : Local APIC
fffc0000-ffffffff : reserved


7.5. lspci -vvv
00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0

00:01.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 
01) (prog-if 8a [Master SecP PriP])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64
         Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [size=8]
         Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [size=1]
         Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [size=8]
         Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [size=1]
         Region 4: I/O ports at d000 [size=16]
         Kernel driver in use: ata_piix

00:02.0 VGA compatible controller: InnoTek Systemberatung GmbH 
VirtualBox Graphics Adapter
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=32M]

00:03.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet 
Controller (rev 02)
         Subsystem: Intel Corporation Device 001e
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64 (63750ns min)
         Interrupt: pin A routed to IRQ 10
         Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=128K]
         Region 2: I/O ports at d010 [size=8]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [e4] PCI-X non-bridge device
                 Command: DPERE- ERO+ RBC=512 OST=1
                 Status: Dev=ff:1f.0 64bit- 133MHz- SCD- USC- DC=simple 
DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
         Kernel driver in use: e1000
         Kernel modules: e1000

00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest 
Service
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 9
         Region 0: I/O ports at d020 [size=32]
         Region 1: Memory at f0400000 (32-bit, non-prefetchable) [size=4M]
         Region 2: Memory at f0800000 (32-bit, prefetchable) [size=16K]
         Kernel driver in use: vboxguest
         Kernel modules: vboxguest

00:05.0 Multimedia audio controller: Intel Corporation 82801AA AC'97 
Audio Controller (rev 01)
         Subsystem: Intel Corporation Device 0000
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64
         Interrupt: pin A routed to IRQ 5
         Region 0: I/O ports at d100 [size=256]
         Region 1: I/O ports at d200 [size=64]
         Kernel driver in use: snd_intel8x0
         Kernel modules: snd-intel8x0

00:06.0 USB Controller: Apple Computer Inc. KeyLargo/Intrepid USB 
(prog-if 10)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at f0804000 (32-bit, non-prefetchable) [size=4K]
         Kernel driver in use: ohci_hcd

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 08)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 9
         Kernel modules: i2c-piix4

00:0b.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB2 EHCI Controller (prog-if 20)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 10
         Region 0: Memory at f0805000 (32-bit, non-prefetchable) [size=4K]
         Kernel driver in use: ehci-pci

00:0d.0 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) 
SATA AHCI Controller (rev 02) (prog-if 01)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64
         Interrupt: pin A routed to IRQ 5
         Region 0: I/O ports at d240 [size=8]
         Region 1: I/O ports at <ignored>
         Region 2: I/O ports at d250 [size=8]
         Region 3: I/O ports at <ignored>
         Region 4: I/O ports at d260 [size=16]
         Region 5: Memory at f0806000 (32-bit, non-prefetchable) [size=8K]
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a8] SATA HBA <?>
         Kernel driver in use: ahci


7.6. cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: VBOX HARDDISK    Rev: 1.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: VBOX     Model: CD-ROM           Rev: 1.0
   Type:   CD-ROM                           ANSI  SCSI revision: 05


7.7. ls /proc
1
10
11
12
13
14
15
16
17
18
19
2
20
21
22
24
25
26
27
28
29
298
3
302
305
320
3229
3233
3234
324
3278
3433
349
350
392
4
40
414
42
43
44
47
48
5
564
620
633
644
67
68
69
7
779
783
786
788
793
8
801
805
806
853
854
855
866
893
9
908
acpi
asound
buddyinfo
bus
cgroups
cmdline
consoles
cpuinfo
crypto
devices
diskstats
dma
dri
driver
execdomains
fb
filesystems
fs
interrupts
iomem
ioports
irq
kallsyms
kcore
key-users
kmsg
kpagecount
kpageflags
latency_stats
loadavg
locks
mdstat
meminfo
misc
modules
mounts
mtrr
net
pagetypeinfo
partitions
sched_debug
schedstat
scsi
self
slabinfo
softirqs
stat
swaps
sys
sysrq-trigger
sysvipc
timer_list
timer_stats
tty
uptime
version
vmallocinfo
vmstat
zoneinfo


8. versions of lvm2, cryptsetup
lvm2 2.02.54-1ubuntu4.1
cryptsetup 2:1.1.0~rc2-1ubuntu13
